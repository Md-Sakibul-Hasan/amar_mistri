# Privacy Policy — Sebaghar

**Last updated:** July 12, 2026

## 1. Introduction

Sebaghar ("we", "our", "us") operates the Sebaghar mobile application (the "App"). This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our App.

By using the App, you agree to the collection and use of information in accordance with this policy.

## 2. Information We Collect

### 2.1 Personal Information You Provide

When you register or use the App, we collect:

| Information | Purpose |
|-------------|---------|
| **Full Name** | To identify you and display your name to other users |
| **Email Address** | For account authentication and login |
| **Phone Number** | To enable communication between customers and service providers |
| **Password** | Securely stored via Firebase Authentication |
| **Profile Photo** | To display your avatar; uploaded via camera or gallery |
| **Location / Service Area** | Free‑text area where you provide services (optional for customers) |

If you register as a **Service Provider**, we also collect:

| Information | Purpose |
|-------------|---------|
| **Services Offered** | To list you under the correct categories |
| **Years of Experience** | To help customers evaluate your expertise |
| **Skills** | To describe your qualifications |
| **NID Number** | For identity verification (providers only) |

### 2.2 Booking & Review Data

- **Booking details**: service type, date, area, notes, priority level
- **Review & rating**: star rating, written comment, and your name/photo (visible to other users)

### 2.3 Device Information

- **FCM device token**: used to send push notifications about booking updates
- **App preferences**: user role, onboarding status, theme, and language settings (stored locally on your device)

### 2.4 Photos/Media

With your permission, we access your device camera and photo library solely to let you upload a profile picture. These images are uploaded to **Cloudflare R2** object storage.

## 3. How We Use Your Information

- To create and manage your account
- To match customers with service providers
- To facilitate bookings and communication
- To send push notifications about booking status changes
- To display provider listings, ratings, and reviews
- To improve our services

## 4. Third‑Party Services

We use the following third‑party services:

| Service | Purpose | Data Shared |
|---------|---------|-------------|
| **Firebase (Google)** | Authentication, database (Cloud Firestore), push notifications (FCM) | Account credentials, user profile, booking data, device tokens |
| **Cloudflare R2** | Image hosting for profile photos | Uploaded profile images |

Firebase and Cloudflare R2 may store data on servers outside your country of residence.

## 5. Data Sharing Between Users

- **Provider profiles** (name, photo, services, ratings) are visible to all customers.
- **Provider phone number** is visible to customers for booking coordination.
- **Customer name and photo** are shared with providers when a booking is made.
- **Reviews** (name, photo, rating, comment) are visible to other users.

## 6. Data Security

We implement appropriate technical measures to protect your data, including encrypted transmission via HTTPS and Firebase's built‑in security rules. However, no method of transmission over the Internet is 100% secure.

## 7. Data Retention

We retain your personal data for as long as your account is active. If you wish to delete your account and associated data, please contact us using the information below.

## 8. Your Rights

You may:
- **Update** your profile information at any time from the Profile page
- **Request deletion** of your account and data by contacting us
- **Withdraw permissions** (camera, gallery, notifications) via your device settings

## 9. Children's Privacy

The App is not directed at individuals under the age of 13. We do not knowingly collect personal information from children.

## 10. Changes to This Policy

We may update this Privacy Policy from time to time. We will notify you of any changes by updating the "Last updated" date at the top.

## 11. Contact Us

If you have questions or concerns about this Privacy Policy, please contact us:

- **Email:** [your‑email@example.com]
- **Address:** [your address]

---

## Play Store Requirements

1. Upload this policy to **https://[your‑domain]/privacy-policy** or paste the full text into the Play Console.
2. The app **does not** collect any personal and sensitive data that requires additional declarations (no health data, financial data, biometrics, etc.).
3. Data category: **App functionality** (the data is required for the core matching/booking service).
