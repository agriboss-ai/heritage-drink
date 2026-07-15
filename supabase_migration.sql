-- ══════════════════════════════════════════════════════════════
-- HERITAGE DRINK — Migration Supabase
-- Exécuter dans : Supabase Dashboard > SQL Editor
-- Projet : https://xwkcpldsainxkwlvkndn.supabase.co
-- ══════════════════════════════════════════════════════════════

-- ── 1. TABLE hd_settings (ligne unique, id=1) ──
CREATE TABLE IF NOT EXISTS hd_settings (
  id             INT PRIMARY KEY,
  whatsapp       TEXT,
  address        TEXT,
  hours          TEXT,
  email          TEXT,
  instagram      TEXT,
  facebook       TEXT,
  promo_active   BOOLEAN DEFAULT false,
  promo_text     TEXT DEFAULT '',
  promo_color    TEXT DEFAULT '#D4A833',
  welcome_active BOOLEAN DEFAULT true,
  welcome_text   TEXT DEFAULT '',
  updated_at     TIMESTAMPTZ DEFAULT NOW()
);

-- ── 2. TABLE hd_products ──
CREATE TABLE IF NOT EXISTS hd_products (
  id          TEXT PRIMARY KEY,
  name        TEXT NOT NULL,
  img         TEXT,
  price       INT NOT NULL DEFAULT 0,
  description TEXT,
  benefits    TEXT,              -- JSON array stringifié, ex: '["Énergie","Local"]'
  badge       TEXT DEFAULT '',
  active      BOOLEAN DEFAULT true,
  sort_order  INT DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── 3. TABLE hd_testimonials ──
CREATE TABLE IF NOT EXISTS hd_testimonials (
  id         SERIAL PRIMARY KEY,
  name       TEXT,
  role       TEXT,
  product    TEXT,
  text       TEXT,
  stars      INT DEFAULT 5,
  type       TEXT DEFAULT 'text' CHECK (type IN ('text','image')),
  img        TEXT,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── 4. TABLE hd_faq ──
CREATE TABLE IF NOT EXISTS hd_faq (
  id         SERIAL PRIMARY KEY,
  question   TEXT NOT NULL,
  answer     TEXT NOT NULL,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── 5. TABLE hd_gallery ──
CREATE TABLE IF NOT EXISTS hd_gallery (
  id         SERIAL PRIMARY KEY,
  img_url    TEXT NOT NULL,
  caption    TEXT,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── 6. STORAGE BUCKET hd-media (public) ──
INSERT INTO storage.buckets (id, name, public)
VALUES ('hd-media', 'hd-media', true)
ON CONFLICT (id) DO NOTHING;

-- ══════════════════════════════════════════════════════════════
-- DONNÉES PAR DÉFAUT (= HD_DEFAULTS actuellement dans index.html)
-- ══════════════════════════════════════════════════════════════

INSERT INTO hd_settings (id, whatsapp, address, hours, email, instagram, facebook, promo_active, promo_text, promo_color, welcome_active, welcome_text)
VALUES (
  1, '22879467455', 'Rue de la Pâture, Lomé, Togo', 'Lundi–Samedi : 8h–18h',
  'heritagedrink@gmail.com', 'https://www.instagram.com/heritagedrink', 'https://www.facebook.com/share/1Bt51b16pG/',
  false, '', '#D4A833',
  true, '🌿 Bienvenue chez Heritage Drink — Où santé et délices se rencontrent'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO hd_products (id, name, img, price, description, benefits, badge, active, sort_order) VALUES
('cocktail',  'Cocktail Heritage',   'Cocktail_Heritage.png',   1000, 'Assemblage quotidien de fruits frais africains pressés à froid.', '["Énergie matinale","Fruits locaux","Zéro sucre"]', '⭐ Signature', true, 1),
('smoothie',  'Smoothie Heritage',   'Smoothie_Heritqge.png',   1000, 'Mangue, pomme, ananas, banane. Un repas dans un verre.', '["Coupe-faim","Riche en fibres","Énergie durable"]', '', true, 2),
('superdote', 'Super Dotè',          'Super_Dotè_Heritage.png', 1000, 'Gingembre + curcuma. Le bouclier quotidien de nos clients.', '["Anti-inflammatoire","Immunité","Digestion"]', '🔥 Populaire', true, 3),
('corossol',  'Corossol Heritage',   'Corossol_Heritqge.png',   1000, 'Fruit rare du terroir togolais. Goût unique, défenses renforcées.', '["Immunité","Fibres","Fruit rare"]', '💎 Rare', true, 4),
('pasteque',  'Pastèque Pure',       'Pastèque_Pure.png',       800,  '100% pastèque. Naturellement hydratant, riche en lycopène.', '["Hydratation max","Antioxydant","Zéro additif"]', '', true, 5),
('orange',    'Orange Heritage',     'Orange_Heritage.png',     800,  '100% orange pressée. Vitamine C maximale.', '["Vitamine C","Immunité","100% naturel"]', '', true, 6),
('detox',     'Power Detox',         'Power_Detox.png',         3000, 'Betterave, citron, concombre, persil. Nettoyage en profondeur.', '["Détox profonde","Légumes frais","Régénérant"]', '🌱 Détox', true, 7),
('coco',      'Eau de Coco',         'Eau_de_coco.png',         600,  'Hydratation naturelle riche en électrolytes.', '["Électrolytes","Post-sport","Légère"]', '', true, 8),
('ail',       "Jus d'Ail Tonus",     'Jus_d_ail_Tonus.png',     3000, 'Ail pressé + citron. Remède ancestral togolais.', '["Antibactérien","Cardiovasculaire","Tonus"]', '💪 Tonus', true, 9)
ON CONFLICT (id) DO NOTHING;

INSERT INTO hd_testimonials (name, role, product, text, stars, type, sort_order) VALUES
('Guy A.', 'Client régulier, Lomé', 'Cocktail Heritage', 'Depuis que j''ai découvert Heritage Drink, je ne veux plus d''autre jus. Goût authentique, fraîcheur réelle !', 5, 'text', 1),
('Jacqueline M.', 'Cliente fidèle', 'Super Dotè', 'Le Super Dotè me fait du bien et m''aide à perdre du poids. J''en ai donné à ma mère et elle a très bien dormi.', 5, 'text', 2),
('Yawa L.', 'Cliente Lomé-Plateau', 'Corossol Heritage', 'Des saveurs locales et naturelles comme on n''en trouve plus ailleurs.', 5, 'text', 3);

INSERT INTO hd_faq (question, answer, sort_order) VALUES
('Vos jus contiennent-ils du sucre ajouté ?', 'Jamais. Aucun sucre raffiné, sirop ou édulcorant. Le goût sucré vient uniquement des fruits.', 1),
('Comment fonctionne le Quiz Santé ?', '3 questions sur votre objectif, votre rythme et vos goûts. Nous recommandons les recettes les plus adaptées.', 2),
('Comment fonctionne une cure personnalisée ?', 'Choisissez objectif, durée (5-21 jours) et jus/jour. Programme jour par jour envoyé via WhatsApp.', 3),
('Comment fonctionne le programme de fidélité ?', '1 commande = 1 point. À 10 pts : jus offert. À 25 pts : pack offert. À 50 pts : statut Premium.', 4),
('Proposez-vous des abonnements ?', 'Pack Santé (5 jus/sem, 4 000 FCFA) et Pack Famille (10 jus/sem, 7 000 FCFA), livrés chaque lundi.', 5),
('Livrez-vous partout à Lomé ?', 'Principaux quartiers de Lomé. Livraison incluse pour les abonnés.', 6),
('Combien de temps se conservent vos jus ?', '24 à 48h au réfrigérateur. Idéalement à consommer le jour même.', 7),
('Puis-je offrir un jus ou une cure ?', 'Oui ! Module Offrir Heritage : choisissez destinataire, occasion et pack. Message personnalisé inclus.', 8);

-- (hd_gallery : pas de données par défaut — la section Communauté affiche des
--  emplacements "photo à ajouter" tant qu'aucune photo n'est ajoutée via l'admin)

-- ══════════════════════════════════════════════════════════════
-- RLS — Lecture publique, écriture ouverte via clé anon
-- (même politique que le reste de l'écosystème Big Village Farm /
--  Agriboss AI : pas d'auth serveur configurée. La clé service_role
--  n'est PAS exposée côté client — admin.html utilise la même clé
--  anon que index.html.)
-- ══════════════════════════════════════════════════════════════

ALTER TABLE hd_settings     ENABLE ROW LEVEL SECURITY;
ALTER TABLE hd_products     ENABLE ROW LEVEL SECURITY;
ALTER TABLE hd_testimonials ENABLE ROW LEVEL SECURITY;
ALTER TABLE hd_faq          ENABLE ROW LEVEL SECURITY;
ALTER TABLE hd_gallery      ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "hd_settings_select_public" ON hd_settings;
CREATE POLICY "hd_settings_select_public" ON hd_settings FOR SELECT USING (true);
DROP POLICY IF EXISTS "hd_settings_write_open" ON hd_settings;
CREATE POLICY "hd_settings_write_open" ON hd_settings FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "hd_products_select_public" ON hd_products;
CREATE POLICY "hd_products_select_public" ON hd_products FOR SELECT USING (true);
DROP POLICY IF EXISTS "hd_products_write_open" ON hd_products;
CREATE POLICY "hd_products_write_open" ON hd_products FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "hd_testimonials_select_public" ON hd_testimonials;
CREATE POLICY "hd_testimonials_select_public" ON hd_testimonials FOR SELECT USING (true);
DROP POLICY IF EXISTS "hd_testimonials_write_open" ON hd_testimonials;
CREATE POLICY "hd_testimonials_write_open" ON hd_testimonials FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "hd_faq_select_public" ON hd_faq;
CREATE POLICY "hd_faq_select_public" ON hd_faq FOR SELECT USING (true);
DROP POLICY IF EXISTS "hd_faq_write_open" ON hd_faq;
CREATE POLICY "hd_faq_write_open" ON hd_faq FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "hd_gallery_select_public" ON hd_gallery;
CREATE POLICY "hd_gallery_select_public" ON hd_gallery FOR SELECT USING (true);
DROP POLICY IF EXISTS "hd_gallery_write_open" ON hd_gallery;
CREATE POLICY "hd_gallery_write_open" ON hd_gallery FOR ALL USING (true) WITH CHECK (true);

-- ── Storage : lecture publique + upload ouvert sur hd-media ──
DROP POLICY IF EXISTS "hd_media_select_public" ON storage.objects;
CREATE POLICY "hd_media_select_public" ON storage.objects FOR SELECT USING (bucket_id = 'hd-media');
DROP POLICY IF EXISTS "hd_media_insert_open" ON storage.objects;
CREATE POLICY "hd_media_insert_open" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'hd-media');

-- ── Vérification ──
SELECT tablename, rowsecurity FROM pg_tables
WHERE schemaname = 'public' AND tablename LIKE 'hd_%';
