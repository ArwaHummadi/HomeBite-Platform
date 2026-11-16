// Platform settings. Every number HomeBite uses (fees, commission, time limits) is a row of the
// PLATFORM_SETTING table, so the administrator can change it later without changing the code.
// This list gives each setting its first value; the seed puts them in the database.

export type SettingType = "int" | "decimal" | "text" | "windows" | "choice";

export interface SettingDef {
  key: string;
  type: SettingType;
  default: string;
  /** Allowed values for "choice" settings */
  choices?: string[];
  /** Grouping on the settings page */
  group: "search" | "money" | "delivery" | "dispatch" | "packages" | "trips" | "security" | "misc";
  label: { ar: string; en: string };
  description: { ar: string; en: string };
}

export const SETTING_DEFS: SettingDef[] = [
  { key: "customer_search_radius_km", type: "decimal", default: "15", group: "search",
    label: { ar: "نطاق البحث (كم)", en: "Customer search radius (km)" },
    description: { ar: "المسافة القصوى بين عنوان العميل والمطبخ حتى تظهر الأسرة له.", en: "Maximum straight-line distance between the customer's address and a kitchen for the kitchen to be listed." } },
  { key: "platform_commission_rate", type: "decimal", default: "20", group: "money",
    label: { ar: "عمولة المنصة (%)", en: "Platform commission rate (%)" },
    description: { ar: "نسبة المنصة من قيمة الوجبات، تُنسخ داخل كل طلب عند إنشائه.", en: "Platform share of the meal value, copied into every order at placement." } },
  { key: "driver_platform_share_rate", type: "decimal", default: "0", group: "money",
    label: { ar: "حصة المنصة من رسوم التوصيل (%)", en: "Driver platform share rate (%)" },
    description: { ar: "النسبة المخصومة من رسوم التوصيل قبل إيداعها في محفظة السائق (0 = لا خصم).", en: "Share deducted from the delivery fee before crediting the driver (0 = none)." } },
  { key: "delivery_base_fee_sar", type: "decimal", default: "7", group: "delivery",
    label: { ar: "رسوم التوصيل الأساسية (ر.س)", en: "Delivery base fee (SAR)" },
    description: { ar: "رسوم التوصيل حتى المسافة الأساسية.", en: "Delivery fee up to the base distance." } },
  { key: "delivery_base_distance_km", type: "decimal", default: "7", group: "delivery",
    label: { ar: "المسافة الأساسية (كم)", en: "Delivery base distance (km)" },
    description: { ar: "المسافة التي تغطيها الرسوم الأساسية.", en: "Distance covered by the base fee." } },
  { key: "delivery_extra_fee_per_km_sar", type: "decimal", default: "1.5", group: "delivery",
    label: { ar: "رسوم كل كم إضافي (ر.س)", en: "Extra fee per km (SAR)" },
    description: { ar: "تُضاف لكل كيلومتر (مقرّب للأعلى) بعد المسافة الأساسية؛ الناتج يُقرّب إلى 0.50 ر.س.", en: "Added per started kilometre beyond the base distance; the result is rounded to 0.50 SAR." } },
  { key: "offer_wave_size", type: "int", default: "3", group: "dispatch",
    label: { ar: "حجم موجة العروض", en: "Offer wave size" },
    description: { ar: "عدد السائقين الذين يُعرض عليهم الطلب في كل موجة.", en: "Number of drivers offered an order in each wave." } },
  { key: "offer_timeout_seconds", type: "int", default: "60", group: "dispatch",
    label: { ar: "مهلة العرض (ثانية)", en: "Offer timeout (seconds)" },
    description: { ar: "مدة صلاحية العرض قبل انتقاله للموجة التالية.", en: "How long an offer stays open before the next wave." } },
  { key: "order_response_timeout_minutes", type: "int", default: "30", group: "dispatch",
    label: { ar: "مهلة رد الأسرة على الطلب (دقيقة)", en: "Cook response timeout (minutes)" },
    description: { ar: "الطلب المعلّق الذي لا تردّ عليه الأسرة خلال هذه المدة يُرفض تلقائياً ويُنشأ طلب استرداد للدفع بالبطاقة.", en: "A pending order not answered by the cook within this time is rejected automatically and a refund is created for card payments." } },
  { key: "order_pending_prompt_minutes", type: "int", default: "5", group: "dispatch",
    label: { ar: "تنبيه العميل بعد (دقيقة)", en: "Customer prompt after (minutes)" },
    description: { ar: "بعد هذه المدة يظهر للعميل خيار الانتظار أو الإلغاء عندما لا تكون الأسرة قد قبلت بعد.", en: "After this time the customer is offered to wait or cancel while the cook has not accepted yet." } },
  { key: "package_validity_default_days", type: "int", default: "30", group: "packages",
    label: { ar: "صلاحية الباقة الافتراضية (يوم)", en: "Package validity default (days)" },
    description: { ar: "الصلاحية الافتراضية عند إنشاء باقة.", en: "Default validity when a cook creates a package." } },
  { key: "package_validity_max_days", type: "int", default: "90", group: "packages",
    label: { ar: "أقصى صلاحية للباقة (يوم)", en: "Package validity maximum (days)" },
    description: { ar: "الحد الأعلى الذي تستطيع الأسرة اختياره.", en: "Upper limit a cook may choose." } },
  { key: "package_booking_lead_time_hours", type: "int", default: "12", group: "packages",
    label: { ar: "مهلة الحجز المسبق (ساعة)", en: "Package booking lead time (hours)" },
    description: { ar: "لا يمكن حجز يوم أو طلب مجدول قبل موعده بأقل من هذه المدة.", en: "A day or window cannot be booked closer than this to its start." } },
  { key: "package_change_cutoff_default_hours", type: "int", default: "4", group: "packages",
    label: { ar: "مهلة تعديل الحجز الافتراضية (ساعة)", en: "Package change cut-off default (hours)" },
    description: { ar: "آخر وقت لإعادة جدولة أو إلغاء يوم محجوز، ما لم تحدد الأسرة مهلتها.", en: "Latest time to reschedule or cancel a booked day unless the cook sets her own." } },
  { key: "package_unbooked_credit_days", type: "int", default: "7", group: "packages",
    label: { ar: "إيداع مبلغ الباقة للأسرة بعد (يوم)", en: "Credit the cook for an unbooked package after (days)" },
    description: { ar: "إذا مرّت هذه المدة من الشراء بدون أي حجز، يُودع صافي مبلغ الباقة في محفظة الأسرة تلقائياً.", en: "If this many days pass after purchase with no booking, the cook's net package amount is credited automatically." } },
  { key: "package_expiry_warning_days", type: "int", default: "3", group: "packages",
    label: { ar: "تحذير قرب انتهاء الباقة قبل (يوم)", en: "Package expiry warning (days before)" },
    description: { ar: "يُرسل تنبيه واحد للعميل قبل انتهاء الباقة بهذه المدة.", en: "One warning is sent to the customer this many days before a package expires." } },
  { key: "max_orders_per_trip", type: "int", default: "5", group: "trips",
    label: { ar: "أقصى عدد طلبات في الرحلة", en: "Maximum orders per trip" },
    description: { ar: "الحد الأعلى لطلبات نفس الأسرة واليوم والفترة في رحلة واحدة.", en: "Upper limit of same-cook, same-day, same-window orders grouped in one trip." } },
  { key: "trip_distance_range_km", type: "decimal", default: "3", group: "trips",
    label: { ar: "نطاق الرحلة (كم)", en: "Trip distance range (km)" },
    description: { ar: "المسافة القصوى بين عناوين عملاء الرحلة الواحدة.", en: "Maximum distance between the customer addresses of one trip." } },
  { key: "delivery_windows", type: "windows", default: "08:00-10:00 فطور; 12:00-14:00 غداء; 19:00-21:00 عشاء", group: "delivery",
    label: { ar: "فترات التوصيل", en: "Delivery windows" },
    description: { ar: "قائمة الفترات الثابتة بصيغة HH:MM-HH:MM اسم؛ مفصولة بفاصلة منقوطة.", en: "Fixed list in the form HH:MM-HH:MM name; separated by semicolons." } },
  { key: "pin_length", type: "int", default: "4", group: "delivery",
    label: { ar: "طول رمز التسليم (PIN)", en: "Delivery PIN length" },
    description: { ar: "عدد أرقام رمز التسليم الذي يُعرض للعميل.", en: "Number of digits of the delivery PIN shown to the customer." } },
  { key: "payout_frequency", type: "choice", default: "weekly", choices: ["weekly", "biweekly", "monthly"], group: "money",
    label: { ar: "دورية التحويلات", en: "Payout frequency" },
    description: { ar: "الدورية المعتمدة لتحويل أرصدة الأسر والسائقين.", en: "How often balances of cooks and drivers are settled." } },
  { key: "location_update_interval_seconds", type: "int", default: "15", group: "dispatch",
    label: { ar: "فاصل تحديث موقع السائق (ثانية)", en: "Location update interval (seconds)" },
    description: { ar: "كل كم ثانية يرسل متصفح السائق موقعه.", en: "How often the driver's browser sends its position." } },
  { key: "chat_refresh_interval_seconds", type: "int", default: "5", group: "misc",
    label: { ar: "فاصل تحديث المحادثة (ثانية)", en: "Chat refresh interval (seconds)" },
    description: { ar: "يُستخدم عندما يتعذر الاتصال اللحظي (WebSocket).", en: "Used when the live WebSocket connection is unavailable." } },
  { key: "featured_ad_price_per_week_sar", type: "decimal", default: "40", group: "money",
    label: { ar: "سعر الإعلان المميز للأسبوع (ر.س)", en: "Featured ad price per week (SAR)" },
    description: { ar: "الأسرة تختار من 1 إلى 4 أسابيع والمبلغ = السعر × الأسابيع.", en: "A cook chooses 1 to 4 weeks; the amount is the price times the weeks." } },
  { key: "login_max_failed_attempts", type: "int", default: "10", group: "security",
    label: { ar: "محاولات الدخول الفاشلة قبل القفل", en: "Failed logins before lockout" },
    description: { ar: "بعد هذا العدد يُقفل الحساب مؤقتاً.", en: "After this many failures the account is locked temporarily." } },
  { key: "login_lockout_minutes", type: "int", default: "15", group: "security",
    label: { ar: "مدة القفل (دقيقة)", en: "Lockout duration (minutes)" },
    description: { ar: "مدة قفل الحساب بعد المحاولات الفاشلة.", en: "How long the account stays locked." } },
  { key: "unpaid_order_timeout_minutes", type: "int", default: "30", group: "money",
    label: { ar: "مهلة إتمام الدفع بالبطاقة (دقيقة)", en: "Card payment completion timeout (minutes)" },
    description: { ar: "الطلب أو الباقة التي لا يكتمل دفعها خلال هذه المدة تُلغى وتُحرَّر السعة.", en: "An order or package whose card payment is not completed within this time is cancelled and its capacity released." } },
];

export const SETTING_KEYS = SETTING_DEFS.map((d) => d.key);
export type SettingKey = (typeof SETTING_DEFS)[number]["key"];

export type SettingsMap = Record<string, string>;

export function settingDefaults(): SettingsMap {
  return Object.fromEntries(SETTING_DEFS.map((d) => [d.key, d.default]));
}

export function num(settings: SettingsMap, key: string): number {
  const def = SETTING_DEFS.find((d) => d.key === key);
  const raw = settings[key] ?? def?.default ?? "0";
  const n = Number(raw);
  return Number.isFinite(n) ? n : Number(def?.default ?? 0);
}

export function int(settings: SettingsMap, key: string): number {
  return Math.round(num(settings, key));
}

export interface DeliveryWindow {
  start: string; // HH:MM
  end: string; // HH:MM
  name: string;
}

/** Parses "08:00-10:00 فطور; 12:00-14:00 غداء" into windows. Invalid parts are skipped. */
export function parseWindows(value: string): DeliveryWindow[] {
  return value
    .split(";")
    .map((p) => p.trim())
    .filter(Boolean)
    .map((p) => {
      const m = p.match(/^(\d{2}:\d{2})-(\d{2}:\d{2})\s*(.*)$/);
      return m ? { start: m[1], end: m[2], name: m[3].trim() } : null;
    })
    .filter((w): w is DeliveryWindow => !!w);
}

export function windows(settings: SettingsMap): DeliveryWindow[] {
  return parseWindows(settings["delivery_windows"] ?? settingDefaults()["delivery_windows"]);
}

/** Validates a raw value for a setting key. Returns an error code or null. */
export function validateSetting(key: string, value: string): string | null {
  const def = SETTING_DEFS.find((d) => d.key === key);
  if (!def) return "unknown_key";
  const v = value.trim();
  if (def.type === "int") return /^\d+$/.test(v) ? null : "int_required";
  if (def.type === "decimal") return /^\d+(\.\d+)?$/.test(v) ? null : "decimal_required";
  if (def.type === "choice") return def.choices!.includes(v) ? null : "invalid_choice";
  if (def.type === "windows") return parseWindows(v).length > 0 ? null : "windows_required";
  return v.length > 0 ? null : "required";
}
