import * as admin from "firebase-admin";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { logger } from "firebase-functions/v2";

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

/**
 * Firestore trigger: fires when a new booking document is created.
 * Reads the provider's FCM tokens and sends a push notification.
 */
export const onBookingCreated = onDocumentCreated(
  "Bookings/{bookingId}",
  async (event) => {
    const booking = event.data?.data();
    if (!booking) {
      logger.warn("onBookingCreated: empty booking snapshot, skipping.");
      return;
    }

    const {
      bookingId,
      providerUid,
      customerName,
      service,
      area,
      priority,
    } = booking as {
      bookingId: string;
      providerUid: string;
      customerName: string;
      service: string;
      area: string;
      priority: string;
    };

    if (!providerUid) {
      logger.warn(`onBookingCreated [${bookingId}]: missing providerUid.`);
      return;
    }

    // Fetch the provider's FCM tokens from the users collection.
    const providerSnap = await db.collection("users").doc(providerUid).get();
    if (!providerSnap.exists) {
      logger.warn(
        `onBookingCreated [${bookingId}]: provider doc not found for uid=${providerUid}.`
      );
      return;
    }

    const fcmTokens: string[] =
      (providerSnap.data()?.fcmTokens as string[]) ?? [];

    if (fcmTokens.length === 0) {
      logger.info(
        `onBookingCreated [${bookingId}]: provider ${providerUid} has no FCM tokens, skipping.`
      );
      return;
    }

    const priorityLabel =
      priority === "urgent" ? "🚨 Urgent" : priority === "high" ? "⚡ High" : "Normal";

    const notification: admin.messaging.Notification = {
      title: "New Booking Request",
      body: `${customerName} booked you for ${service} in ${area} [${priorityLabel}]`,
    };

    const payload: admin.messaging.MulticastMessage = {
      notification,
      data: {
        bookingId,
        type: "new_booking",
        providerUid,
        customerName,
        service,
        area,
        priority,
      },
      android: {
        priority: "high",
        notification: {
          channelId: "high_importance_channel",
          priority: "high",
          sound: "default",
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
            badge: 1,
          },
        },
      },
      tokens: fcmTokens,
    };

    const response = await messaging.sendEachForMulticast(payload);
    logger.info(
      `onBookingCreated [${bookingId}]: sent to ${fcmTokens.length} token(s). ` +
      `Success=${response.successCount}, Failure=${response.failureCount}`
    );

    // Remove stale tokens that are no longer valid.
    const staleTokens: string[] = [];
    response.responses.forEach((res, idx) => {
      if (
        !res.success &&
        (res.error?.code === "messaging/invalid-registration-token" ||
          res.error?.code === "messaging/registration-token-not-registered")
      ) {
        staleTokens.push(fcmTokens[idx]);
      }
    });

    if (staleTokens.length > 0) {
      await db
        .collection("users")
        .doc(providerUid)
        .update({
          fcmTokens: admin.firestore.FieldValue.arrayRemove(...staleTokens),
        });
      logger.info(
        `onBookingCreated [${bookingId}]: removed ${staleTokens.length} stale token(s) for provider ${providerUid}.`
      );
    }
  }
);
