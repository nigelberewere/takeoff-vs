# Takeoff driver onboarding

React + Vite + TypeScript frontend for a courier driver application flow. Supabase provides real email/password authentication, email OTP verification, Postgres persistence, private document storage, and row-level security.

## Run locally

1. Copy `.env.example` to `.env.local` and add your Supabase project URL and anon key.
2. In Supabase SQL Editor, run `supabase/schema.sql`.
3. In Supabase Auth settings, enable email confirmations and configure the email template to include the 6-digit token (`{{ .Token }}`).
4. Install and run:

```bash
npm install
npm run dev
```

## Supabase data

Registration sends a real Supabase email OTP. Verification creates the driver profile, personal and vehicle steps update Postgres rows, and the documents step uploads selected files to the private `driver-documents` bucket before writing document metadata. The final action sets `drivers.application_status` to `pending_review`. The app restores an authenticated application and displays its stored status on refresh. Use the Supabase Table Editor and Storage browser to inspect test submissions.

## Deploy

Build with `npm run build`, then import the repository into Vercel or Netlify. Add `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` as production environment variables before deploying.
