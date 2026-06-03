import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../locale/locale_cubit.dart';

class AppLocalizations {
  final bool _bn;

  const AppLocalizations._(this._bn);

  factory AppLocalizations.of(BuildContext context) {
    final locale = context.read<LocaleCubit>().state;
    return AppLocalizations._(locale.languageCode == 'bn');
  }

  String _t(String en, String bn) => _bn ? bn : en;

  // ── Common ─────────────────────────────────────────────────────────────────
  String get appName => 'Amar Mistri';
  String get cancel => _t('Cancel', 'বাতিল');
  String get save => _t('Save', 'সংরক্ষণ');
  String get logout => _t('Logout', 'লগআউট');
  String get profile => _t('Profile', 'প্রোফাইল');
  String get retry => _t('Retry', 'পুনরায় চেষ্টা করুন');
  String get pleaseWait => _t('Please wait...', 'অপেক্ষা করুন...');
  String get darkMode => _t('Dark Mode', 'ডার্ক মোড');
  String get lightMode => _t('Light Mode', 'লাইট মোড');
  String get language => _t('Language', 'ভাষা');
  String get selectLanguage => _t('Select Language', 'ভাষা নির্বাচন করুন');
  String get viewAll => _t('View all', 'সবগুলো দেখুন');
  String get seeAll => _t('See all', 'সবগুলো দেখুন');
  String get bookNow => _t('Book Now', 'এখনই বুক করুন');
  String get logoutConfirmTitle => _t('Logout', 'লগআউট');
  String get logoutConfirmBody => _t('Are you sure you want to logout?', 'আপনি কি সত্যিই লগআউট করতে চান?');
  String get noBookingsYet => _t('No bookings yet', 'এখনো কোনো বুকিং নেই');
  String get noBookingsYetDot => _t('No bookings yet.', 'এখনো কোনো বুকিং নেই।');
  String get phoneNumberCopied => _t('Phone number copied', 'ফোন নম্বর কপি হয়েছে');

  // ── Greetings ──────────────────────────────────────────────────────────────
  String get greetingMorning => _t('Good Morning', 'শুভ সকাল');
  String get greetingAfternoon => _t('Good Afternoon', 'শুভ অপরাহ্ন');
  String get greetingEvening => _t('Good Evening', 'শুভ সন্ধ্যা');

  // ── Splash ─────────────────────────────────────────────────────────────────
  String get splashTagline => _t('Find trusted local services near you', 'বিশ্বস্ত স্থানীয় সেবা খুঁজুন');

  // ── Role selection ─────────────────────────────────────────────────────────
  String get roleSelectionSubtitle => _t('How would you like to continue?', 'আপনি কীভাবে এগিয়ে যেতে চান?');
  String get roleCustomerTitle => _t('I need a service', 'আমার সেবা দরকার');
  String get roleCustomerSubtitle => _t('Find and hire skilled professionals', 'দক্ষ পেশাদার খুঁজুন ও নিয়োগ করুন');
  String get roleProviderTitle => _t('I provide services', 'আমি সেবা প্রদান করি');
  String get roleProviderSubtitle => _t('Offer your skills and grow your business', 'আপনার দক্ষতা অফার করুন এবং ব্যবসা বাড়ান');

  // ── Auth header ────────────────────────────────────────────────────────────
  String get providerPortal => _t('Provider Portal', 'প্রদানকারী পোর্টাল');
  String get localServicePartner => _t('Your local service partner', 'আপনার স্থানীয় সেবার সঙ্গী');

  // ── Login ──────────────────────────────────────────────────────────────────
  String get welcomeBack => _t('Welcome Back!', 'স্বাগতম!');
  String get loginToContinue => _t('Login to continue', 'চালিয়ে যেতে লগইন করুন');
  String get emailAddress => _t('Email Address', 'ইমেইল ঠিকানা');
  String get emailHint => _t('you@example.com', 'you@example.com');
  String get password => _t('Password', 'পাসওয়ার্ড');
  String get enterPassword => _t('Enter password', 'পাসওয়ার্ড লিখুন');
  String get forgotPassword => _t('Forgot Password?', 'পাসওয়ার্ড ভুলে গেছেন?');
  String get loginButton => _t('Login', 'লগইন');
  String get orContinueWith => _t('or continue with', 'বা এর সাথে চালিয়ে যান');
  String get noAccount => _t("Don't have an account? ", 'অ্যাকাউন্ট নেই? ');
  String get signUp => _t('Sign Up', 'নিবন্ধন করুন');
  String get validEmailError => _t('Enter a valid email', 'সঠিক ইমেইল লিখুন');
  String get minSixCharsError => _t('Min 6 characters', 'ন্যূনতম ৬ অক্ষর');

  // ── Register ───────────────────────────────────────────────────────────────
  String get createAccount => _t('Create Account', 'অ্যাকাউন্ট তৈরি করুন');
  String get signUpToGetStarted => _t('Sign up to get started', 'শুরু করতে নিবন্ধন করুন');
  String get fullName => _t('Full Name', 'পুরো নাম');
  String get fullNameHint => _t('John Doe', 'যেমন: আব্দুর রহিম');
  String get phoneNumber => _t('Phone Number', 'ফোন নম্বর');
  String get servicesOffered => _t('Services Offered', 'প্রদানকৃত সেবাসমূহ');
  String get experienceYears => _t('Experience (Years)', 'অভিজ্ঞতা (বছর)');
  String get experienceHint => _t('e.g. 3', 'যেমন: ৩');
  String get serviceAreaLabel => _t('Service Area', 'সেবা এলাকা');
  String get serviceAreaHint => _t('Enter your service area', 'আপনার সেবা এলাকা লিখুন');
  String get nidLabel => _t('NID / ID Number', 'জাতীয় পরিচয়পত্র নম্বর');
  String get nidHint => _t('National ID or other ID', 'জাতীয় পরিচয়পত্র বা অন্য আইডি');
  String get skillsLabel => _t('Skills (Optional)', 'দক্ষতা (ঐচ্ছিক)');
  String get skillsHint => _t('e.g. Solar panel installation, inverter repair', 'যেমন: সোলার প্যানেল, ইনভার্টার মেরামত');
  String get minSixHint => _t('Min. 6 characters', 'ন্যূনতম ৬ অক্ষর');
  String get confirmPassword => _t('Confirm Password', 'পাসওয়ার্ড নিশ্চিত করুন');
  String get reEnterPassword => _t('Re-enter password', 'পুনরায় পাসওয়ার্ড লিখুন');
  String get createAccountButton => _t('Create Account', 'অ্যাকাউন্ট তৈরি করুন');
  String get orSignUpWith => _t('or sign up with', 'বা দিয়ে নিবন্ধন করুন');
  String get alreadyHaveAccount => _t('Already have an account? ', 'ইতিমধ্যে অ্যাকাউন্ট আছে? ');
  String get selectAtLeastOneService => _t('Please select at least one service.', 'অন্তত একটি সেবা নির্বাচন করুন।');
  String get enterYourName => _t('Enter your name', 'আপনার নাম লিখুন');
  String get enterYearsOfExp => _t('Enter years of experience', 'অভিজ্ঞতার বছর লিখুন');
  String get enterValidNumber => _t('Enter a valid number', 'সঠিক সংখ্যা লিখুন');
  String get enterServiceArea => _t('Enter your service area', 'আপনার সেবা এলাকা লিখুন');
  String get enterNid => _t('Enter your NID / ID number', 'আপনার জাতীয় পরিচয়পত্র নম্বর লিখুন');
  String get passwordsDontMatch => _t('Passwords do not match', 'পাসওয়ার্ড মেলে না');

  // ── Profile ────────────────────────────────────────────────────────────────
  String get editProfile => _t('Edit profile', 'প্রোফাইল সম্পাদনা');
  String get basicInformation => _t('Basic Information', 'মৌলিক তথ্য');
  String get email => _t('Email', 'ইমেইল');
  String get phone => _t('Phone', 'ফোন');
  String get professionalDetails => _t('Professional Details', 'পেশাদার বিবরণ');
  String get experienceYearsLabel => _t('Experience (years)', 'অভিজ্ঞতা (বছর)');
  String get skills => _t('Skills', 'দক্ষতা');
  String get nidNumber => _t('NID Number', 'জাতীয় পরিচয়পত্র নম্বর');
  String get noServicesAdded => _t('No services added', 'কোনো সেবা যোগ করা হয়নি');
  String get cannotBeChanged => _t('Cannot be changed', 'পরিবর্তন করা যাবে না');
  String get nameIsRequired => _t('Name is required', 'নাম প্রয়োজন');
  String get phoneIsRequired => _t('Phone is required', 'ফোন প্রয়োজন');
  String get takeAPhoto => _t('Take a photo', 'ছবি তুলুন');
  String get chooseFromGallery => _t('Choose from gallery', 'গ্যালারি থেকে বেছে নিন');
  String get profilePhotoUpdated => _t('Profile photo updated', 'প্রোফাইল ছবি আপডেট হয়েছে');
  String get profileUpdatedSuccessfully => _t('Profile updated successfully', 'প্রোফাইল সফলভাবে আপডেট হয়েছে');

  // ── Home header ────────────────────────────────────────────────────────────
  String get locationText => _t('Rajshahi, Bangladesh', 'রাজশাহী, বাংলাদেশ');
  String get searchHint => _t('Search for a service...', 'একটি সেবা খুঁজুন...');
  String get setServiceArea => _t('Set service area', 'সেবা এলাকা সেট করুন');
  String get onlineAcceptingBookings => _t('You are currently online and accepting bookings', 'আপনি এখন অনলাইন এবং বুকিং গ্রহণ করছেন');

  // ── Customer home ──────────────────────────────────────────────────────────
  String get myBookings => _t('My Bookings', 'আমার বুকিং');
  String get myBookingsSubtitle => _t('View all your booking requests and details', 'আপনার সকল বুকিং অনুরোধ ও বিবরণ দেখুন');

  // ── Categories ─────────────────────────────────────────────────────────────
  String get ourServices => _t('Our Services', 'আমাদের সেবাসমূহ');
  String get electrician => _t('Electrician', 'ইলেকট্রিশিয়ান');
  String get plumber => _t('Plumber', 'প্লাম্বার');
  String get acRepair => _t('AC Repair', 'এসি মেরামত');
  String get painter => _t('Painter', 'পেইন্টার');
  String get carpenter => _t('Carpenter', 'কাঠমিস্ত্রি');
  String get homeCleaner => _t('Home Cleaner', 'বাড়ি পরিষ্কারক');
  String get mason => _t('Mason / Civil', 'রাজমিস্ত্রি');
  String get gasTechnician => _t('Gas Technician', 'গ্যাস টেকনিশিয়ান');
  String get welder => _t('Welder', 'ঝালাইকারী');
  String get cctvSecurity => _t('CCTV / Security', 'সিসিটিভি / নিরাপত্তা');

  List<(String, String)> get categories => [
    (electrician, '⚡'),
    (plumber, '🔧'),
    (acRepair, '❄️'),
    (painter, '🎨'),
    (carpenter, '🪚'),
    (homeCleaner, '🧹'),
    (mason, '🧱'),
    (gasTechnician, '🔥'),
    (welder, '⚙️'),
    (cctvSecurity, '📹'),
  ];

  // ── Top providers ──────────────────────────────────────────────────────────
  String get topProviders => _t('Top Providers', 'শীর্ষ সেবাদাতা');
  String get topRated => _t('Top Rated', 'শীর্ষ রেটেড');
  String get verified => _t('Verified', 'যাচাইকৃত');
  String get popular => _t('Popular', 'জনপ্রিয়');

  // ── How it works ───────────────────────────────────────────────────────────
  String get howItWorks => _t('How Amar Mistri Works', 'আমার মিস্ত্রি যেভাবে কাজ করে');
  String get stepPickService => _t('Pick Service', 'সেবা বেছে নিন');
  String get stepChoosePro => _t('Choose Pro', 'পেশাদার বেছে নিন');
  String get stepBookDone => _t('Book & Done!', 'বুক করুন!');

  // ── Banner ─────────────────────────────────────────────────────────────────
  String get banner1Title => _t('50% OFF', '৫০% ছাড়');
  String get banner1Sub => _t('First booking discount', 'প্রথম বুকিং ছাড়');
  String get banner2Title => _t('AC Special', 'এসি স্পেশাল');
  String get banner2Sub => _t('Summer service package', 'গ্রীষ্মকালীন সেবা প্যাকেজ');
  String get bannerBookNow => _t('Book Now', 'এখনই বুক করুন');

  // ── Booking page ───────────────────────────────────────────────────────────
  String get bookService => _t('Book Service', 'সেবা বুক করুন');
  String get bookingJobDetailsHint =>
      _t('Provide job details so the provider can prepare properly.', 'কাজের বিবরণ দিন যাতে সেবাদাতা ঠিকমতো প্রস্তুতি নিতে পারেন।');
  String get bookingForm => _t('Booking Form', 'বুকিং ফর্ম');
  String get area => _t('Area', 'এলাকা');
  String get areaHint => _t('Ex: Mirpur-10, Dhaka', 'যেমন: মিরপুর-১০, ঢাকা');
  String get areaRequired => _t('Area is required', 'এলাকা প্রয়োজন');
  String get noteDescription => _t('Note / Description', 'নোট / বিবরণ');
  String get describeTheProblem => _t('Describe the problem clearly', 'সমস্যাটি স্পষ্টভাবে বর্ণনা করুন');
  String get descriptionRequired => _t('Description is required', 'বিবরণ প্রয়োজন');
  String get priority => _t('Priority', 'অগ্রাধিকার');
  String get normal => _t('Normal', 'সাধারণ');
  String get urgent => _t('Urgent', 'জরুরি');
  String get emergency => _t('Emergency', 'জরুরি অবস্থা');
  String get confirmBooking => _t('Confirm Booking', 'বুকিং নিশ্চিত করুন');

  // ── Booking confirm ────────────────────────────────────────────────────────
  String get bookingConfirmed => _t('Booking Confirmed!', 'বুকিং নিশ্চিত হয়েছে!');
  String get bookingConfirmedBody => _t(
    'Your booking request has been submitted successfully. '
        'The provider will review it and get back to you soon.',
    'আপনার বুকিং অনুরোধ সফলভাবে জমা দেওয়া হয়েছে। '
        'সেবাদাতা এটি পর্যালোচনা করবেন এবং শীঘ্রই যোগাযোগ করবেন।',
  );
  String get whatHappensNext => _t('What happens next?', 'পরবর্তীতে কি হবে?');
  String get whatHappensNextBody => _t(
    'The provider will confirm your request and contact you to schedule a visit.',
    'সেবাদাতা আপনার অনুরোধ নিশ্চিত করবেন এবং পরিদর্শনের সময়সূচি নির্ধারণে যোগাযোগ করবেন।',
  );
  String get stayNotified => _t('Stay notified', 'সতর্কবার্তা পান');
  String get stayNotifiedBody =>
      _t('You will receive a notification once the provider accepts your booking.', 'সেবাদাতা আপনার বুকিং গ্রহণ করলে আপনি একটি বিজ্ঞপ্তি পাবেন।');
  String get viewMyBookings => _t('View My Bookings', 'আমার বুকিং দেখুন');
  String get backToHome => _t('Back to Home', 'হোমে ফিরে যান');

  // ── Booking list ───────────────────────────────────────────────────────────
  String get bookingsYetBody => _t('Your bookings will appear here after you place one.', 'বুকিং করলে এখানে দেখাবে।');
  String get couldNotLoadBookings => _t('Could not load bookings', 'বুকিং লোড করা যায়নি');

  // ── Booking details ────────────────────────────────────────────────────────
  String get bookingDetails => _t('Booking Details', 'বুকিং বিবরণ');
  String get summary => _t('Summary', 'সারসংক্ষেপ');
  String get bookingId => _t('Booking ID', 'বুকিং আইডি');
  String get status => _t('Status', 'অবস্থা');
  String get date => _t('Date', 'তারিখ');
  String get created => _t('Created', 'তৈরি হয়েছে');
  String get serviceInfo => _t('Service Info', 'সেবার তথ্য');
  String get service => _t('Service', 'সেবা');
  String get provider => _t('Provider', 'সেবাদাতা');
  String get customerInfo => _t('Customer Info', 'গ্রাহকের তথ্য');
  String get name => _t('Name', 'নাম');
  String get description => _t('Description', 'বিবরণ');

  // ── Provider details ───────────────────────────────────────────────────────
  String get available => _t('Available', 'উপলব্ধ');
  String get experience => _t('Experience', 'অভিজ্ঞতা');
  String get services => _t('Services', 'সেবাসমূহ');
  String get contact => _t('Contact', 'যোগাযোগ');
  String get call => _t('Call', 'কল করুন');
  String get whatsapp => _t('WhatsApp', 'হোয়াটসঅ্যাপ');
  String experienceYearsValue(int years) => _bn ? '$years বছর' : '$years years';

  // ── Provider home ──────────────────────────────────────────────────────────
  String get totalJobs => _t('Total Jobs', 'মোট কাজ');
  String get thisMonth => _t('This Month', 'এই মাসে');
  String get rating => _t('Rating', 'রেটিং');

  // ── Quick actions ──────────────────────────────────────────────────────────
  String get quickActions => _t('Quick Actions', 'দ্রুত কার্যক্রম');
  String get bookings => _t('Bookings', 'বুকিং');
  String get reviews => _t('Reviews', 'পর্যালোচনা');

  // ── Recent bookings ────────────────────────────────────────────────────────
  String get recentBookings => _t('Recent Bookings', 'সাম্প্রতিক বুকিং');

  // ── All bookings ───────────────────────────────────────────────────────────
  String get allBookings => _t('All Bookings', 'সকল বুকিং');

  // ── Booking detail sheet ───────────────────────────────────────────────────
  String get bookingSummary => _t('Booking Summary', 'বুকিং সারসংক্ষেপ');
  String get submitted => _t('Submitted', 'জমা দেওয়া হয়েছে');
  String get reject => _t('Reject', 'প্রত্যাখ্যান করুন');
  String get accept => _t('Accept', 'গ্রহণ করুন');
  String get complete => _t('Complete', 'সম্পন্ন করুন');
  String get bookingAccepted => _t('Booking accepted', 'বুকিং গ্রহণ করা হয়েছে');
  String get bookingCompleted => _t('Booking completed', 'বুকিং সম্পন্ন হয়েছে');
  String get bookingRejected => _t('Booking rejected', 'বুকিং প্রত্যাখ্যান করা হয়েছে');
  String serviceLabel(String s) => _bn ? 'সেবা: $s' : 'Service: $s';

  // ── Earnings ───────────────────────────────────────────────────────────────
  String get earningsOverview => _t('Earnings Overview', 'উপার্জনের সারসংক্ষেপ');
  String get totalEarningsThisMonth => _t('Total earnings this month', 'এই মাসে মোট উপার্জন');
  String get jobsDone => _t('Jobs Done', 'সম্পন্ন কাজ');
  String get avgPerJob => _t('Avg/Job', 'গড়/কাজ');
  String get pending => _t('Pending', 'মুলতুবি');

  // ── Tips ───────────────────────────────────────────────────────────────────
  String get tipsToEarnMore => _t('Tips to Earn More', 'আরও উপার্জন করার টিপস');
  String get stayOnline => _t('Stay Online', 'অনলাইনে থাকুন');
  String get respondFast => _t('Respond Fast', 'দ্রুত সাড়া দিন');
  String get earnMore => _t('Earn More!', 'আরও উপার্জন করুন!');

  // ── Providers List ─────────────────────────────────────────────────────────
  String get seeDetails => _t('See Details', 'বিস্তারিত দেখুন');
  String noProvidersFound(String service) => _bn ? 'কোনো $service প্রদানকারী পাওয়া যায়নি' : 'No $service providers found';
  String get checkBackSoon => _t('Check back soon — more are joining!', 'শীঘ্রই আবার দেখুন — আরও যোগ দিচ্ছেন!');
  String get somethingWentWrong => _t('Something went wrong', 'কিছু একটা ভুল হয়েছে');
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
