# NYUMBA24 — Dar es Salaam

Website ya kutafuta na kutangaza nyumba za kupanga Dar es Salaam. Imeandaliwa kutumia Supabase (database) na Vercel (hosting).

## Kilichounganishwa kwenye code
- Kusoma matangazo yaliyoidhinishwa kutoka Supabase `properties`.
- Kutafuta kwa eneo, aina ya nyumba na bajeti; kupanga bei.
- Kutuma tangazo jipya kwenye Supabase kama `pending`.
- Kuonyesha maelezo na kiungo cha kuwasiliana na mwenye nyumba kupitia WhatsApp.
- Hakuna matangazo ya mfano yanayoonyeshwa kama nyumba halisi.

## Hatua za mwisho zinazohitajika kwenye akaunti yako

### 1. Weka credentials
Fungua `config.js` na badilisha:
- `https://YOUR-PROJECT-REF.supabase.co` kwa Project URL halisi.
- `WEKA_ANON_AU_PUBLISHABLE_KEY_HAPA` kwa anon/public au publishable key.

Tumia public client key tu. Usiweke `service_role` au secret key kwenye website.

### 2. Tengeneza jedwali
Supabase Dashboard → SQL Editor → New query. Bandika na uendeshe `supabase/schema.sql`.

### 3. Idhinisha matangazo
Matangazo yanayotumwa yanakuwa `pending`, kwa hiyo hayaonekani hadharani mpaka uyakague. Kwenye Supabase Table Editor → `properties`, badilisha `status` kuwa `approved` kwa tangazo lililothibitishwa. Hakuna admin dashboard ndani ya tovuti hii bado.

### 4. Jaribu locally
Fungua `index.html` kupitia local web server au tumia Vercel Preview baada ya kuweka config. Fungua website, hakikisha status inasema database imeunganishwa, tuma tangazo la majaribio, kisha likague kwenye Supabase.

### 5. Hosting ya Vercel
1. Pakia folder hili kwenye GitHub repository.
2. Vercel → Add New → Project → import repository.
3. Framework Preset: Other; Build Command na Output Directory viache wazi.
4. Deploy. Vercel itakupa URL ya umma.

## Muhimu kabla ya uzinduzi
- URL ya live haiwezi kutengenezwa hadi project ipakiwe kwenye akaunti ya hosting na Deploy ikamilike.
- Picha kwa sasa huwekwa kwa kutumia picha URL; Supabase Storage upload bado haijaongezwa.
- Hakuna login/admin dashboard, uthibitishaji wa simu, CAPTCHA, au uthibitishaji wa umiliki wa nyumba. Msimamizi aidhinishe matangazo kwa mkono kabla ya kuyaonyesha.
- Weka sera ya faragha na masharti ya matumizi kabla ya uzinduzi wa kibiashara.
