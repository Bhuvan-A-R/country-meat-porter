# Country Meat Porter — Driver User Workflow

This document describes what a delivery partner (porter / driver) does in the app, step by step, from first launch through a completed trip.

App entry: splash → login. Bottom tabs after login: **Duty Home**, **My Tasks**, **Earnings**, **Driver Profile**.

---

## 1. App launch (splash)

1. Driver opens the Country Meat Porter app.
2. Splash screen loads the partner portal (hub connection, GPS / cold-chain, assigned deliveries).
3. After a few seconds the app goes to **Login**.

---

## 2. Sign in (existing partner)

1. On **Welcome Back, Partner**, the driver enters:
   - Mobile number (`+91`, 10 digits)
   - Password
2. Optional extras on this screen:
   - **Biometric Login** (fingerprint / face — currently a placeholder)
   - **Forgot Password?** (reset SMS — currently a placeholder)
   - **Register As Partner** if they do not have an account (jumps to Sign up)
3. Driver taps **LOGIN & CONTINUE**.
4. App sends them to **OTP verification** with `isRegister = false`.

### OTP (sign in)

5. Driver sees the number the OTP was sent to and can edit it (goes back) if it is wrong.
6. Driver enters the **4-digit SMS OTP**.
7. If the timer runs out, they can **Resend OTP**.
8. Driver taps **VERIFY & CONTINUE**.
9. App opens **Duty Home** (dashboard). Profile setup is skipped for returning users.

---

## 3. Sign up (new partner)

1. From login, driver taps **Register As Partner**.
2. On **Create Partner Account**, they enter:
   - Mobile number (`+91`)
   - New password
   - Confirm password
3. If they already have an account they tap **Sign In Here**.
4. Driver taps **REGISTER & GET OTP**.
5. App sends them to **OTP verification** with `isRegister = true`.

### OTP (sign up)

6. Same OTP steps as sign in (enter 4-digit PIN, resend if needed).
7. Driver taps **VERIFY & CONTINUE**.
8. App opens **Enter Your Profile Details** (KYC-lite setup).

### Profile details (new partner only)

9. Driver adds:
   - Profile photo (plus on avatar)
   - **Name**
   - **Age**
   - **Aadhaar card** photo (upload dropzone)
10. Driver taps **Complete**.
11. Name is saved on the partner profile and the app opens **Duty Home**.

---

## 4. Duty Home (daily start)

Bottom tab: **Duty Home**.

1. Driver sees their name, vehicle type, and registration number.
2. They can open **Partner Notifications** (bell):
   - Surge bonuses
   - COD cash deposit reminders
   - KYC / vehicle approval
   - Mark one or all as read
3. They see today’s **Total Payout**, **COD Collected**, and **Trips Done**.
4. Tapping **COD Collected** opens the cash-deposit sheet (same as Earnings).
5. Driver goes **ONLINE** so they can receive tasks:
   - Offline → tap the duty banner to go online
   - Online → tap the banner, confirm **GO OFFLINE** if they want to stop new orders
6. While online:
   - If there is an active task, the **Current Active Task** card is shown
   - If there is no active task, they wait for assignment (demo can restart a trip)
7. From the active task card they can:
   - Open full trip details
   - Open **Google Maps** to store or customer
   - Call store or customer
   - Play **voice guidance** (if enabled in Profile)
   - Open the **Cold Chain** reminder (keep meat chilled, deliver on time)
8. Quick actions:
   - **My Tasks** → task list
   - **COD Deposit** → hub handover
   - **SOS Support** → emergency numbers

---

## 5. Receive a delivery and complete the trip

A live order moves through: **Assigned → Arrived at store → Picked up → In transit → Delivered**.

Driver can start from Duty Home (active card) or **My Tasks** → tap a trip.

### Step A — Assigned (go to store)

1. Driver reads store name, address, distance, ETA, payout, and COD amount if any.
2. They navigate to the store (Maps) and can call the store.
3. At the store they **slide to confirm ARRIVED AT STORE**.

### Step B — Arrived at store (verify items)

4. Driver checks every meat pack / ice gel pack against the list.
5. They tick each item, or tap **VERIFY ALL SEALS (QUICK CHECK)**.
6. Pickup is blocked until every item is verified.
7. They **slide to confirm ORDER PICKUP**.

### Step C — Picked up / in transit (go to customer)

8. Driver navigates to the customer address.
9. They follow customer instructions (e.g. leave with security).
10. They can call the customer if needed.
11. They keep the cold chain (chilled packs, no long delays).

### Step D — Deliver

12. Driver **slides to confirm delivery**.

**If Cash on Delivery (COD):**

13. Collect the cash amount shown.
14. Attach a **COD payment screenshot** from gallery.
15. Tap **CONTINUE TO OTP**.
16. Enter the customer’s **4-digit delivery OTP**.
17. Tap **CONFIRM DELIVERY**.

**If prepaid (no COD):**

13. Skip screenshot.
14. Enter the customer’s **4-digit delivery OTP**.
15. Tap **CONFIRM DELIVERY**.

### Step E — Trip complete

18. App marks the trip **Delivered**, credits porter payout, and adds COD cash to today’s collected total (if COD).
19. Completion summary is shown; driver returns to **Duty Home**.
20. They wait for the next assignment or go offline.

---

## 6. My Tasks

Bottom tab: **My Tasks**.

1. **Active Tasks** — assigned / in-progress trips. Tap a card to open trip details and continue the steps above.
2. **Completed Trips** — finished deliveries for the day.

---

## 7. Earnings and COD cash handover

Bottom tab: **Earnings**.

1. Driver reviews:
   - This week’s total payout
   - Today’s payout
   - Trips done
   - Bonus level
   - Weekly incentive progress (e.g. 50 trips for extra bonus)
   - Completed trip log
2. They open **TODAY'S CASH SETTLEMENT** to settle collected cash at a store hub **before 9:00 PM**.
3. On the deposit sheet they:
   - See the settlement amount
   - Pick a hub (e.g. Indiranagar, Whitefield) with timing and distance
   - Tap **GENERATE PAYMENT QR CODE**
   - Choose Google Pay, PhonePe, Paytm, or another UPI / payment gateway
   - Complete payment and see the amount, selected app, hub, and settlement reference

---

## 8. Driver Profile

Bottom tab: **Driver Profile**.

1. Driver views Partner ID, phone, KYC / vehicle verified badge.
2. They check vehicle type, registration number, and base hub.
3. They check rating and completed deliveries.
4. **Voice Read-Aloud Assistant** — on/off, language: English / Hindi / Kannada (used on Duty Home for spoken next-step instructions).
5. **EMERGENCY SOS & ROADSIDE HELP**:
   - Country Meat dispatch hotline
   - EV scooter breakdown (battery, tyre, mechanical)
   - Police / ambulance (112)
6. **Log Out** returns them to Login.

---

## End-to-end picture

```
Splash
  → Login  ──────────────────────────────────────────────┐
       │ Sign in: phone + password → OTP                 │
       │ Sign up: phone + passwords → OTP → Profile KYC  │
       └──────────────────────────────→ Duty Home        │
                                              │          │
                    ┌─────────────────────────┼──────────┤
                    │                         │          │
              My Tasks                  Earnings    Profile
                    │                         │          │
              Open trip                   COD QR      SOS
                    │                    Hub deposit  Voice
                    ▼                         │       Logout ──→ Login
         Assigned → Arrive store → Verify items
           → Pickup → Navigate to customer
           → (COD screenshot if cash) → Delivery OTP
           → Delivered → payout credited → next trip
```

---

## Notes (current app)

- Auth, OTP, biometric, forgot-password, Aadhaar upload, and hub QR are **UI flows** in this prototype; they are not wired to a live backend yet.
- Duty starts **online** in demo data so an assigned trip is visible immediately after login.
- After all demo trips are delivered, Duty Home can **restart the trip process demo**.
