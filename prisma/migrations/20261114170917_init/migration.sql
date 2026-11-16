-- CreateEnum
CREATE TYPE "AccountStatus" AS ENUM ('active', 'suspended');

-- CreateEnum
CREATE TYPE "Language" AS ENUM ('ar', 'en');

-- CreateEnum
CREATE TYPE "ApprovalStatus" AS ENUM ('pending', 'approved', 'rejected');

-- CreateEnum
CREATE TYPE "FulfillmentType" AS ENUM ('delivery', 'pickup');

-- CreateEnum
CREATE TYPE "OrderType" AS ENUM ('instant', 'scheduled', 'package');

-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('pending', 'preparing', 'ready', 'on_the_way', 'delivered', 'rejected', 'cancelled');

-- CreateEnum
CREATE TYPE "PurchaseStatus" AS ENUM ('pending', 'active', 'completed', 'expired', 'cancelled');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('card', 'cash');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('pending', 'paid', 'partially_refunded', 'refunded');

-- CreateEnum
CREATE TYPE "RefundStatus" AS ENUM ('pending', 'succeeded', 'failed');

-- CreateEnum
CREATE TYPE "OfferResponse" AS ENUM ('pending', 'accepted', 'rejected', 'expired');

-- CreateEnum
CREATE TYPE "TripStatus" AS ENUM ('planned', 'in_progress', 'completed', 'cancelled');

-- CreateEnum
CREATE TYPE "WalletTxType" AS ENUM ('order_credit', 'package_credit', 'delivery_credit', 'cash_share', 'compensation', 'payout', 'adjustment');

-- CreateEnum
CREATE TYPE "FeaturedStatus" AS ENUM ('pending', 'active', 'expired', 'cancelled');

-- CreateEnum
CREATE TYPE "SenderRole" AS ENUM ('customer', 'cook', 'driver');

-- CreateTable
CREATE TABLE "customer" (
    "customer_id" SERIAL NOT NULL,
    "full_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "account_status" "AccountStatus" NOT NULL DEFAULT 'active',
    "preferred_language" "Language" NOT NULL DEFAULT 'ar',
    "allergies" TEXT,
    "dietary_notes" TEXT,
    "notifications_seen_at" TIMESTAMP(3),
    "failed_login_attempts" INTEGER NOT NULL DEFAULT 0,
    "locked_until" TIMESTAMP(3),
    "reset_token_hash" TEXT,
    "reset_token_expires_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "customer_pkey" PRIMARY KEY ("customer_id")
);

-- CreateTable
CREATE TABLE "admin" (
    "admin_id" SERIAL NOT NULL,
    "full_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "account_status" "AccountStatus" NOT NULL DEFAULT 'active',
    "preferred_language" "Language" NOT NULL DEFAULT 'ar',
    "failed_login_attempts" INTEGER NOT NULL DEFAULT 0,
    "locked_until" TIMESTAMP(3),
    "reset_token_hash" TEXT,
    "reset_token_expires_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "admin_pkey" PRIMARY KEY ("admin_id")
);

-- CreateTable
CREATE TABLE "city" (
    "city_id" SERIAL NOT NULL,
    "name_ar" TEXT NOT NULL,
    "name_en" TEXT NOT NULL,

    CONSTRAINT "city_pkey" PRIMARY KEY ("city_id")
);

-- CreateTable
CREATE TABLE "home_cook" (
    "cook_id" SERIAL NOT NULL,
    "full_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "account_status" "AccountStatus" NOT NULL DEFAULT 'active',
    "preferred_language" "Language" NOT NULL DEFAULT 'ar',
    "kitchen_name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "bio" TEXT NOT NULL,
    "logo" TEXT,
    "city_id" INTEGER NOT NULL,
    "district" TEXT NOT NULL,
    "latitude" DECIMAL(9,6) NOT NULL,
    "longitude" DECIMAL(9,6) NOT NULL,
    "maps_link" TEXT NOT NULL,
    "permit_document" TEXT NOT NULL,
    "approval_status" "ApprovalStatus" NOT NULL DEFAULT 'pending',
    "approved_at" TIMESTAMP(3),
    "rejection_reason" TEXT,
    "daily_capacity" INTEGER NOT NULL DEFAULT 10,
    "auto_accept" BOOLEAN NOT NULL DEFAULT false,
    "is_open_now" BOOLEAN NOT NULL DEFAULT false,
    "open_override_at" TIMESTAMP(3),
    "package_change_hours" INTEGER,
    "avg_rating" DECIMAL(3,2) NOT NULL DEFAULT 0,
    "notifications_seen_at" TIMESTAMP(3),
    "failed_login_attempts" INTEGER NOT NULL DEFAULT 0,
    "locked_until" TIMESTAMP(3),
    "reset_token_hash" TEXT,
    "reset_token_expires_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "home_cook_pkey" PRIMARY KEY ("cook_id")
);

-- CreateTable
CREATE TABLE "cook_working_hours" (
    "working_hours_id" SERIAL NOT NULL,
    "cook_id" INTEGER NOT NULL,
    "weekday" INTEGER NOT NULL,
    "open_time" VARCHAR(5) NOT NULL,
    "close_time" VARCHAR(5) NOT NULL,

    CONSTRAINT "cook_working_hours_pkey" PRIMARY KEY ("working_hours_id")
);

-- CreateTable
CREATE TABLE "cook_day" (
    "cook_day_id" SERIAL NOT NULL,
    "cook_id" INTEGER NOT NULL,
    "day" DATE NOT NULL,
    "is_closed" BOOLEAN NOT NULL DEFAULT false,
    "capacity_override" INTEGER,

    CONSTRAINT "cook_day_pkey" PRIMARY KEY ("cook_day_id")
);

-- CreateTable
CREATE TABLE "driver" (
    "driver_id" SERIAL NOT NULL,
    "full_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "account_status" "AccountStatus" NOT NULL DEFAULT 'active',
    "preferred_language" "Language" NOT NULL DEFAULT 'ar',
    "vehicle_type" TEXT NOT NULL,
    "plate_number" TEXT NOT NULL,
    "id_document" TEXT NOT NULL,
    "license_document" TEXT NOT NULL,
    "vehicle_registration_document" TEXT NOT NULL,
    "approval_status" "ApprovalStatus" NOT NULL DEFAULT 'pending',
    "approved_at" TIMESTAMP(3),
    "rejection_reason" TEXT,
    "is_available" BOOLEAN NOT NULL DEFAULT false,
    "last_latitude" DECIMAL(9,6),
    "last_longitude" DECIMAL(9,6),
    "last_location_at" TIMESTAMP(3),
    "avg_rating" DECIMAL(3,2) NOT NULL DEFAULT 0,
    "notifications_seen_at" TIMESTAMP(3),
    "failed_login_attempts" INTEGER NOT NULL DEFAULT 0,
    "locked_until" TIMESTAMP(3),
    "reset_token_hash" TEXT,
    "reset_token_expires_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "driver_pkey" PRIMARY KEY ("driver_id")
);

-- CreateTable
CREATE TABLE "driver_location" (
    "location_id" SERIAL NOT NULL,
    "driver_id" INTEGER NOT NULL,
    "order_id" INTEGER,
    "latitude" DECIMAL(9,6) NOT NULL,
    "longitude" DECIMAL(9,6) NOT NULL,
    "recorded_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "driver_location_pkey" PRIMARY KEY ("location_id")
);

-- CreateTable
CREATE TABLE "address" (
    "address_id" SERIAL NOT NULL,
    "customer_id" INTEGER NOT NULL,
    "label" TEXT NOT NULL,
    "city_id" INTEGER NOT NULL,
    "district" TEXT NOT NULL,
    "street_details" TEXT NOT NULL,
    "latitude" DECIMAL(9,6) NOT NULL,
    "longitude" DECIMAL(9,6) NOT NULL,
    "maps_link" TEXT NOT NULL,
    "is_default" BOOLEAN NOT NULL DEFAULT false,
    "is_deleted" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "address_pkey" PRIMARY KEY ("address_id")
);

-- CreateTable
CREATE TABLE "meal" (
    "meal_id" SERIAL NOT NULL,
    "cook_id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,
    "image" TEXT,
    "prep_time_minutes" INTEGER,
    "allergens" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "is_available_today" BOOLEAN NOT NULL DEFAULT true,
    "unavailable_on" DATE,

    CONSTRAINT "meal_pkey" PRIMARY KEY ("meal_id")
);

-- CreateTable
CREATE TABLE "meal_day" (
    "meal_id" INTEGER NOT NULL,
    "weekday" INTEGER NOT NULL,

    CONSTRAINT "meal_day_pkey" PRIMARY KEY ("meal_id","weekday")
);

-- CreateTable
CREATE TABLE "package" (
    "package_id" SERIAL NOT NULL,
    "cook_id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "meals_count" INTEGER NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,
    "validity_days" INTEGER NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "package_pkey" PRIMARY KEY ("package_id")
);

-- CreateTable
CREATE TABLE "package_meal" (
    "package_id" INTEGER NOT NULL,
    "meal_id" INTEGER NOT NULL,
    "quantity" INTEGER,

    CONSTRAINT "package_meal_pkey" PRIMARY KEY ("package_id","meal_id")
);

-- CreateTable
CREATE TABLE "package_purchase" (
    "purchase_id" SERIAL NOT NULL,
    "package_id" INTEGER NOT NULL,
    "customer_id" INTEGER NOT NULL,
    "address_id" INTEGER,
    "fulfillment_type" "FulfillmentType" NOT NULL,
    "purchased_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" DATE NOT NULL,
    "total_meals" INTEGER NOT NULL,
    "remaining_meals" INTEGER NOT NULL,
    "meals_amount" DECIMAL(10,2) NOT NULL,
    "delivery_fee_per_delivery" DECIMAL(10,2) NOT NULL,
    "delivery_amount_prepaid" DECIMAL(10,2) NOT NULL,
    "total_paid" DECIMAL(10,2) NOT NULL,
    "commission_rate" DECIMAL(5,2) NOT NULL,
    "commission_amount" DECIMAL(10,2) NOT NULL,
    "distance_km" DECIMAL(6,2),
    "status" "PurchaseStatus" NOT NULL DEFAULT 'pending',
    "cook_credited_at" TIMESTAMP(3),
    "expiry_warned_at" TIMESTAMP(3),

    CONSTRAINT "package_purchase_pkey" PRIMARY KEY ("purchase_id")
);

-- CreateTable
CREATE TABLE "order" (
    "order_id" SERIAL NOT NULL,
    "customer_id" INTEGER NOT NULL,
    "cook_id" INTEGER NOT NULL,
    "order_type" "OrderType" NOT NULL,
    "purchase_id" INTEGER,
    "fulfillment_type" "FulfillmentType" NOT NULL,
    "address_id" INTEGER,
    "scheduled_date" DATE,
    "window_start" VARCHAR(5),
    "window_end" VARCHAR(5),
    "status" "OrderStatus" NOT NULL DEFAULT 'pending',
    "subtotal" DECIMAL(10,2) NOT NULL,
    "delivery_fee" DECIMAL(10,2) NOT NULL,
    "commission_rate" DECIMAL(5,2) NOT NULL,
    "commission_amount" DECIMAL(10,2) NOT NULL,
    "total_amount" DECIMAL(10,2) NOT NULL,
    "distance_km" DECIMAL(6,2),
    "delivery_pin" TEXT NOT NULL,
    "cash_collected" DECIMAL(10,2),
    "driver_id" INTEGER,
    "trip_id" INTEGER,
    "customer_notes" TEXT,
    "placed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "accepted_at" TIMESTAMP(3),
    "ready_at" TIMESTAMP(3),
    "picked_up_at" TIMESTAMP(3),
    "delivered_at" TIMESTAMP(3),
    "cancelled_at" TIMESTAMP(3),
    "cancel_reason" TEXT,
    "dispatch_state" TEXT,
    "dispatch_cycles" INTEGER NOT NULL DEFAULT 0,
    "no_driver_notified_at" TIMESTAMP(3),
    "reminder_sent_at" TIMESTAMP(3),
    "pending_prompt_at" TIMESTAMP(3),

    CONSTRAINT "order_pkey" PRIMARY KEY ("order_id")
);

-- CreateTable
CREATE TABLE "order_item" (
    "order_item_id" SERIAL NOT NULL,
    "order_id" INTEGER NOT NULL,
    "meal_id" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    "unit_price" DECIMAL(10,2) NOT NULL,
    "line_total" DECIMAL(10,2) NOT NULL,

    CONSTRAINT "order_item_pkey" PRIMARY KEY ("order_item_id")
);

-- CreateTable
CREATE TABLE "payment" (
    "payment_id" SERIAL NOT NULL,
    "order_id" INTEGER,
    "purchase_id" INTEGER,
    "amount" DECIMAL(10,2) NOT NULL,
    "method" "PaymentMethod" NOT NULL,
    "card_type" TEXT,
    "card_last4" TEXT,
    "status" "PaymentStatus" NOT NULL DEFAULT 'pending',
    "paid_at" TIMESTAMP(3),
    "gateway_reference" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_pkey" PRIMARY KEY ("payment_id")
);

-- CreateTable
CREATE TABLE "refund" (
    "refund_id" SERIAL NOT NULL,
    "payment_id" INTEGER NOT NULL,
    "order_id" INTEGER,
    "purchase_id" INTEGER,
    "order_item_id" INTEGER,
    "amount" DECIMAL(10,2) NOT NULL,
    "reason" TEXT NOT NULL,
    "status" "RefundStatus" NOT NULL DEFAULT 'pending',
    "gateway_reference" TEXT,
    "requested_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "processed_at" TIMESTAMP(3),
    "approved_by" INTEGER,
    "failure_reason" TEXT,

    CONSTRAINT "refund_pkey" PRIMARY KEY ("refund_id")
);

-- CreateTable
CREATE TABLE "wallet_transaction" (
    "transaction_id" SERIAL NOT NULL,
    "cook_id" INTEGER,
    "driver_id" INTEGER,
    "type" "WalletTxType" NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "order_id" INTEGER,
    "purchase_id" INTEGER,
    "refund_id" INTEGER,
    "transfer_reference" TEXT,
    "description" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_by" INTEGER,

    CONSTRAINT "wallet_transaction_pkey" PRIMARY KEY ("transaction_id")
);

-- CreateTable
CREATE TABLE "featured_subscription" (
    "featured_id" SERIAL NOT NULL,
    "cook_id" INTEGER NOT NULL,
    "start_date" DATE NOT NULL,
    "end_date" DATE NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "status" "FeaturedStatus" NOT NULL DEFAULT 'pending',
    "payment_id" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "featured_subscription_pkey" PRIMARY KEY ("featured_id")
);

-- CreateTable
CREATE TABLE "delivery_offer" (
    "offer_id" SERIAL NOT NULL,
    "order_id" INTEGER NOT NULL,
    "driver_id" INTEGER NOT NULL,
    "wave_number" INTEGER NOT NULL,
    "cycle" INTEGER NOT NULL DEFAULT 1,
    "offered_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "response" "OfferResponse" NOT NULL DEFAULT 'pending',
    "responded_at" TIMESTAMP(3),

    CONSTRAINT "delivery_offer_pkey" PRIMARY KEY ("offer_id")
);

-- CreateTable
CREATE TABLE "delivery_trip" (
    "trip_id" SERIAL NOT NULL,
    "driver_id" INTEGER NOT NULL,
    "cook_id" INTEGER NOT NULL,
    "trip_date" DATE NOT NULL,
    "pickup_window_start" VARCHAR(5) NOT NULL,
    "pickup_window_end" VARCHAR(5) NOT NULL,
    "delivery_window_start" VARCHAR(5) NOT NULL,
    "delivery_window_end" VARCHAR(5) NOT NULL,
    "status" "TripStatus" NOT NULL DEFAULT 'planned',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "delivery_trip_pkey" PRIMARY KEY ("trip_id")
);

-- CreateTable
CREATE TABLE "rating" (
    "rating_id" SERIAL NOT NULL,
    "order_id" INTEGER NOT NULL,
    "customer_id" INTEGER NOT NULL,
    "cook_id" INTEGER,
    "driver_id" INTEGER,
    "stars" INTEGER NOT NULL,
    "comment" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "rating_pkey" PRIMARY KEY ("rating_id")
);

-- CreateTable
CREATE TABLE "message" (
    "message_id" SERIAL NOT NULL,
    "customer_id" INTEGER NOT NULL,
    "cook_id" INTEGER,
    "driver_id" INTEGER,
    "order_id" INTEGER,
    "sender_role" "SenderRole" NOT NULL,
    "body" TEXT NOT NULL,
    "sent_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "is_read" BOOLEAN NOT NULL DEFAULT false,
    "email_sent" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "message_pkey" PRIMARY KEY ("message_id")
);

-- CreateTable
CREATE TABLE "platform_setting" (
    "setting_key" TEXT NOT NULL,
    "setting_value" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_by" INTEGER,

    CONSTRAINT "platform_setting_pkey" PRIMARY KEY ("setting_key")
);

-- CreateIndex
CREATE UNIQUE INDEX "customer_email_key" ON "customer"("email");

-- CreateIndex
CREATE UNIQUE INDEX "admin_email_key" ON "admin"("email");

-- CreateIndex
CREATE UNIQUE INDEX "home_cook_email_key" ON "home_cook"("email");

-- CreateIndex
CREATE UNIQUE INDEX "home_cook_slug_key" ON "home_cook"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "cook_working_hours_cook_id_weekday_key" ON "cook_working_hours"("cook_id", "weekday");

-- CreateIndex
CREATE UNIQUE INDEX "cook_day_cook_id_day_key" ON "cook_day"("cook_id", "day");

-- CreateIndex
CREATE UNIQUE INDEX "driver_email_key" ON "driver"("email");

-- CreateIndex
CREATE INDEX "driver_location_driver_id_recorded_at_idx" ON "driver_location"("driver_id", "recorded_at");

-- CreateIndex
CREATE INDEX "meal_cook_id_idx" ON "meal"("cook_id");

-- CreateIndex
CREATE INDEX "package_cook_id_idx" ON "package"("cook_id");

-- CreateIndex
CREATE INDEX "package_purchase_customer_id_idx" ON "package_purchase"("customer_id");

-- CreateIndex
CREATE INDEX "order_customer_id_idx" ON "order"("customer_id");

-- CreateIndex
CREATE INDEX "order_cook_id_scheduled_date_idx" ON "order"("cook_id", "scheduled_date");

-- CreateIndex
CREATE INDEX "order_driver_id_idx" ON "order"("driver_id");

-- CreateIndex
CREATE INDEX "order_status_idx" ON "order"("status");

-- CreateIndex
CREATE INDEX "order_item_order_id_idx" ON "order_item"("order_id");

-- CreateIndex
CREATE UNIQUE INDEX "payment_order_id_key" ON "payment"("order_id");

-- CreateIndex
CREATE UNIQUE INDEX "payment_purchase_id_key" ON "payment"("purchase_id");

-- CreateIndex
CREATE INDEX "refund_payment_id_idx" ON "refund"("payment_id");

-- CreateIndex
CREATE INDEX "wallet_transaction_cook_id_idx" ON "wallet_transaction"("cook_id");

-- CreateIndex
CREATE INDEX "wallet_transaction_driver_id_idx" ON "wallet_transaction"("driver_id");

-- CreateIndex
CREATE INDEX "featured_subscription_cook_id_idx" ON "featured_subscription"("cook_id");

-- CreateIndex
CREATE INDEX "delivery_offer_order_id_idx" ON "delivery_offer"("order_id");

-- CreateIndex
CREATE INDEX "delivery_offer_driver_id_response_idx" ON "delivery_offer"("driver_id", "response");

-- CreateIndex
CREATE INDEX "delivery_trip_driver_id_trip_date_idx" ON "delivery_trip"("driver_id", "trip_date");

-- CreateIndex
CREATE UNIQUE INDEX "rating_order_id_cook_id_key" ON "rating"("order_id", "cook_id");

-- CreateIndex
CREATE UNIQUE INDEX "rating_order_id_driver_id_key" ON "rating"("order_id", "driver_id");

-- CreateIndex
CREATE INDEX "message_customer_id_cook_id_sent_at_idx" ON "message"("customer_id", "cook_id", "sent_at");

-- CreateIndex
CREATE INDEX "message_order_id_sent_at_idx" ON "message"("order_id", "sent_at");

-- AddForeignKey
ALTER TABLE "home_cook" ADD CONSTRAINT "home_cook_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "city"("city_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cook_working_hours" ADD CONSTRAINT "cook_working_hours_cook_id_fkey" FOREIGN KEY ("cook_id") REFERENCES "home_cook"("cook_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cook_day" ADD CONSTRAINT "cook_day_cook_id_fkey" FOREIGN KEY ("cook_id") REFERENCES "home_cook"("cook_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "driver_location" ADD CONSTRAINT "driver_location_driver_id_fkey" FOREIGN KEY ("driver_id") REFERENCES "driver"("driver_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "driver_location" ADD CONSTRAINT "driver_location_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "order"("order_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "address" ADD CONSTRAINT "address_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customer"("customer_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "address" ADD CONSTRAINT "address_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "city"("city_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meal" ADD CONSTRAINT "meal_cook_id_fkey" FOREIGN KEY ("cook_id") REFERENCES "home_cook"("cook_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meal_day" ADD CONSTRAINT "meal_day_meal_id_fkey" FOREIGN KEY ("meal_id") REFERENCES "meal"("meal_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "package" ADD CONSTRAINT "package_cook_id_fkey" FOREIGN KEY ("cook_id") REFERENCES "home_cook"("cook_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "package_meal" ADD CONSTRAINT "package_meal_package_id_fkey" FOREIGN KEY ("package_id") REFERENCES "package"("package_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "package_meal" ADD CONSTRAINT "package_meal_meal_id_fkey" FOREIGN KEY ("meal_id") REFERENCES "meal"("meal_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "package_purchase" ADD CONSTRAINT "package_purchase_package_id_fkey" FOREIGN KEY ("package_id") REFERENCES "package"("package_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "package_purchase" ADD CONSTRAINT "package_purchase_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customer"("customer_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "package_purchase" ADD CONSTRAINT "package_purchase_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "address"("address_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order" ADD CONSTRAINT "order_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customer"("customer_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order" ADD CONSTRAINT "order_cook_id_fkey" FOREIGN KEY ("cook_id") REFERENCES "home_cook"("cook_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order" ADD CONSTRAINT "order_purchase_id_fkey" FOREIGN KEY ("purchase_id") REFERENCES "package_purchase"("purchase_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order" ADD CONSTRAINT "order_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "address"("address_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order" ADD CONSTRAINT "order_driver_id_fkey" FOREIGN KEY ("driver_id") REFERENCES "driver"("driver_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order" ADD CONSTRAINT "order_trip_id_fkey" FOREIGN KEY ("trip_id") REFERENCES "delivery_trip"("trip_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_item" ADD CONSTRAINT "order_item_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "order"("order_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_item" ADD CONSTRAINT "order_item_meal_id_fkey" FOREIGN KEY ("meal_id") REFERENCES "meal"("meal_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment" ADD CONSTRAINT "payment_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "order"("order_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment" ADD CONSTRAINT "payment_purchase_id_fkey" FOREIGN KEY ("purchase_id") REFERENCES "package_purchase"("purchase_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refund" ADD CONSTRAINT "refund_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "payment"("payment_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refund" ADD CONSTRAINT "refund_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "order"("order_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refund" ADD CONSTRAINT "refund_purchase_id_fkey" FOREIGN KEY ("purchase_id") REFERENCES "package_purchase"("purchase_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refund" ADD CONSTRAINT "refund_order_item_id_fkey" FOREIGN KEY ("order_item_id") REFERENCES "order_item"("order_item_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refund" ADD CONSTRAINT "refund_approved_by_fkey" FOREIGN KEY ("approved_by") REFERENCES "admin"("admin_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallet_transaction" ADD CONSTRAINT "wallet_transaction_cook_id_fkey" FOREIGN KEY ("cook_id") REFERENCES "home_cook"("cook_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallet_transaction" ADD CONSTRAINT "wallet_transaction_driver_id_fkey" FOREIGN KEY ("driver_id") REFERENCES "driver"("driver_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallet_transaction" ADD CONSTRAINT "wallet_transaction_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "order"("order_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallet_transaction" ADD CONSTRAINT "wallet_transaction_purchase_id_fkey" FOREIGN KEY ("purchase_id") REFERENCES "package_purchase"("purchase_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallet_transaction" ADD CONSTRAINT "wallet_transaction_refund_id_fkey" FOREIGN KEY ("refund_id") REFERENCES "refund"("refund_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallet_transaction" ADD CONSTRAINT "wallet_transaction_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "admin"("admin_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "featured_subscription" ADD CONSTRAINT "featured_subscription_cook_id_fkey" FOREIGN KEY ("cook_id") REFERENCES "home_cook"("cook_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "featured_subscription" ADD CONSTRAINT "featured_subscription_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "payment"("payment_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "delivery_offer" ADD CONSTRAINT "delivery_offer_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "order"("order_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "delivery_offer" ADD CONSTRAINT "delivery_offer_driver_id_fkey" FOREIGN KEY ("driver_id") REFERENCES "driver"("driver_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "delivery_trip" ADD CONSTRAINT "delivery_trip_driver_id_fkey" FOREIGN KEY ("driver_id") REFERENCES "driver"("driver_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "delivery_trip" ADD CONSTRAINT "delivery_trip_cook_id_fkey" FOREIGN KEY ("cook_id") REFERENCES "home_cook"("cook_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rating" ADD CONSTRAINT "rating_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "order"("order_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rating" ADD CONSTRAINT "rating_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customer"("customer_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rating" ADD CONSTRAINT "rating_cook_id_fkey" FOREIGN KEY ("cook_id") REFERENCES "home_cook"("cook_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rating" ADD CONSTRAINT "rating_driver_id_fkey" FOREIGN KEY ("driver_id") REFERENCES "driver"("driver_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "message" ADD CONSTRAINT "message_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customer"("customer_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "message" ADD CONSTRAINT "message_cook_id_fkey" FOREIGN KEY ("cook_id") REFERENCES "home_cook"("cook_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "message" ADD CONSTRAINT "message_driver_id_fkey" FOREIGN KEY ("driver_id") REFERENCES "driver"("driver_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "message" ADD CONSTRAINT "message_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "order"("order_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_setting" ADD CONSTRAINT "platform_setting_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "admin"("admin_id") ON DELETE SET NULL ON UPDATE CASCADE;
