# Model vroeggeboorte (`preterm-32w`)

Deze notitie beschrijft het predictiemodel voor vroeggeboorte in `tab10`: welke variabelen het nodig heeft, waar de risicoberekening staat, hoe je het model op een dataset toepast, en hoe het via JAMES op individuele data werkt.

## 1. Overzicht

| Kenmerk | Waarde |
|------------------------------------|------------------------------------|
| Interne naam (`outcome`) | `preterm-32w` |
| Uitkomst | vroeggeboorte \< 32 weken (24–32 volledige weken, zie script-tekst) |
| Moment van gebruik | bezoek bij 16–20 weken zwangerschap |
| Modeltype | logistische regressie, gefit op CBS-gekoppelde data (M. Hendriks, 2023) |
| Bron van de gewichten | `data-raw/data/vroeg24_37_betas.txt` (tab-gescheiden, decimale komma) |
| Prevalentie in validatiedata | 0,83 % (ongeveer 1 op 120) |
| Weergave | Tafel van Tien met 10.000 zwangerschappen in 100 risicogroepen (`ntab = 10000`) |

De risicoschatting is

```         
lp = -4.11456 + som van de gewichten van alle voorspellers
p  = expit(lp) = 1 / (1 + exp(-lp))
```

De rang (0–100) volgt uit `p2rank(p, "preterm-32w")`. Die functie interpoleert in `risk_rank_data` en vergelijkt het risico daarmee met de verdeling van voorspelde kansen in de CBS-populatie.

> Let op de naamgeving: `vroeg24_37` in de bestandsnaam verwijst naar de voorspeller *aantal eerdere vroeggeboorten 24–37 weken*. De uitkomst is vroeggeboorte \< 32 weken. Dat blijkt uit `outcome`, de UI-labels, de script-teksten en de prevalentie van 1 op 120. Controleer dit bij een volgende modelversie bij de modelbouwer.

## 2. Benodigde variabelen

Alle voorspellers zijn categorisch, behalve *Leeftijd moeder*. Per voorspeller zoekt `beta_lookup(categorie, voorspeller, "preterm-32w")` het gewicht op in `tab10::betas`. De kolom *Bij onbekend* laat zien welk gewicht de categorie `"Onbekend"` krijgt. Dat is een impliciete imputatie.

| \# | Voorspeller (`Voorspeller` in `betas`) | Shiny-input | Categorieën (`Categorie`) | CBS-modelterm | Bij onbekend |
|------------|------------|------------|------------|------------|------------|
| 1 | Geslacht | `sex_pt` | Jongen, Meisje, Onbekend | `geslmannelijk` | 0,0788 (half jongen) |
| 2 | \# vroeggeboorten 24-37w | `N_vroeg_24_37_pt` | 0, 1, 2, 3, 3+, Onbekend | `N_vroeg_24_37*` | 0 (= "0") |
| 3 | In voorafgaande zwangerschap (vroeggeboorte) | `vooraf_zw_vroeg_24_37_pt` | Nee, Ja, Onbekend | `vooraf_zw_vroeg_24_37nee` | = Nee |
| 4 | \# voorafgaande SGA | `N_vooraf_sga_pt` | nvt, 0, 1, 2, 3, 4, 5+, Onbekend | `N_vooraf_sga*` | 0 (= "0") |
| 5 | SGA voorafgaande zwangerschap | `vooraf_sga_pt` | Nee, Ja, Onbekend | `vooraf_sganee` | = Nee |
| 6 | Interpregnantie interval | `interpreg_cat_pt` | nvt, \<6, 6-12, 12-18, 18-24, 24-30, \>30 maanden, Onbekend | `interpreg_cat*` | = 6-12 maanden |
| 7 | Amenorroeduur bij start (zorg) | `amddd1ond_cat_pt` | 0-70 dagen, 71-112 dagen, \>112 dagen, Onbekend | `amddd1ond_cat*` | = 0-70 dagen |
| 8 | Graviditeit | `grav_cat_pt` | 1 … 9, 10+, Onbekend | `grav_cat*` | 0 (= "1") |
| 9 | Opleiding vader | `father_educ_pt` | Basis, VMBO, MBO 2, MBO 3-4, HAVO/VWO, HBO/WO, Onbekend | `educationlevel_fa*` | = HBO, WO |
| 10 | Leeftijd vader (bij conceptie) | `father_age_pt` | 11-15, 16-20, …, 66-70, 71+, Onbekend | `age_at_concp_fa_cat*` | eigen term `vader_NA` (0,272) |
| 11 | Opleiding moeder | `mother_educ_pt` | als vader | `educationlevel_mo*` | = HBO, WO |
| 12 | Leeftijd moeder (bij conceptie, jaren, continu) | `mother_age_pt` | getal | `lft_concep` (0,03524 per jaar) | 32 jaar |
| 13 | Rol moeder in huishouden | `plhh_partner_child_pt` | Thuiswonend kind, Alleenstaand zonder kind, Partner zonder kind, Partner met kind, Alleenstaand met kind, Overig, Onbekend | `plhh_partner_child*` | = Partner met kind |
| 14 | Besteedbaar inkomen huishouden | `income_hh_mo_cat_pt` | Bestaansminimum, Laag, Midden, Hoog, Onbekend | `income_hh_mo_cat*` | = Midden |
| 15 | Woningbezit | `house_ownership_mo_pt` | Eigen woning, Huurwoning met huurtoeslag, Huurwoning zonder huurtoeslag, Onbekend | `house_ownership_mo*` | 0 (= eigen woning) |
| 16 | Stedelijkheid | afgeleid uit `pc4_pt` | Zeer sterk … Niet stedelijk, Onbekend | `STED_mo2..5` | = Sterk stedelijk |
| 17 | COROP-regio | afgeleid uit `pc4_pt` | 1 … 40, Onbekend | `COROP2020_mo02..40` | 0 (= regio 1) |

De referentiecategorie (gewicht 0) is steeds de eerste categorie, behalve bij items 3 en 5, waar "Ja" de referentie is.

Stedelijkheid en COROP volgen uit de 4-cijferige postcode via `tab10::pc4` (kolommen `urb` en `COROP`). Bij een onbekende postcode worden beide "Onbekend".

**Aanpassingen ten opzichte van de ruwe CBS-coëfficiënten** (in `data-raw/R/define_betas.R`):

- `N_vooraf_sga5+` had een instabiele schatting van −9,27 (SE 55,6). Die is handmatig vervangen door 0,7.
- Termen met `NA` in het CBS-model (`vooraf_sganvt`, `vooraf_zw_vroeg_24_37nvt`, `N_vroeg_24_37nvt`, `interpreg_cat<6 months`) zijn collineair met andere "eerste zwangerschap"-indicatoren en krijgen gewicht 0.
- De labels van *Leeftijd vader* (11-15, 16-20, …) wijken af van de CBS-klassen (16-21, 21-26, …). De volgorde komt wel overeen.

## 3. Waar staat de risicoberekening?

| Onderdeel | Locatie |
|------------------------------------|------------------------------------|
| Ruwe CBS-coëfficiënten | [data-raw/data/vroeg24_37_betas.txt](data/vroeg24_37_betas.txt) |
| Vertaling naar voorspeller × categorie × gewicht | [data-raw/R/define_betas.R:114-206](R/define_betas.R#L114-L206) → `tab10::betas` (`outcome == "preterm-32w"`) |
| Opzoeken van een gewicht | [R/beta_lookup.R](../R/beta_lookup.R) |
| Lineaire predictor + `expit()` | [shiny/app_james.R:1249-1336](../shiny/app_james.R#L1249-L1336) (`preterm_risk()`, `preterm_rank()`); dezelfde code staat in `shiny/app.R` en `shiny/app_jesse.R` |
| Invoerkaarten (UI) | [shiny/app_james.R:373-590](../shiny/app_james.R#L373-L590) (`cards_pt`) |
| Rang uit risico | `p2rank()` in [R/risk2rank.R](../R/risk2rank.R), op basis van `tab10::risk_rank_data` |
| Populatieverdeling van voorspelde kansen | [data-raw/R/save_predictions.R](R/save_predictions.R) → `tab10::predictions` (10.000 getrokken uit `voorspeldekansen_vroeggeboorte_logreg_vroeg24_37.xlsx`) |
| Tafel van Tien-teksten | [data-raw/R/define_scripts.R](R/define_scripts.R) (`script_preterm_32w_1`) |
| Visualisatie | `create_tab10(pri = preterm_risk(), outcome = "preterm-32w", ntab = 10000)` |

Er is in het pakket geen aparte functie voor het vroeggeboortemodel. De berekening staat inline in de Shiny-server van elke app.

## 4. Toepassen op een dataset

De onderstaande functie doet hetzelfde als de app, maar dan gevectoriseerd over de rijen van een data frame. Elke kolom bevat de categorieën uit de tabel in §2, als tekst. `NA` of `""` wordt `"Onbekend"`. De postcode (`pc4`) is numeriek.

``` r
library(tab10)

predict_preterm <- function(data) {
  b <- subset(tab10::betas, outcome == "preterm-32w")
  w <- function(predictor, x) {
    x <- ifelse(is.na(x) | x == "", "Onbekend", as.character(x))
    bb <- b[b$Voorspeller == predictor, ]
    out <- bb$Gewicht[match(x, bb$Categorie)]
    if (anyNA(out)) stop("Onbekende categorie bij ", predictor, ": ",
                         paste(unique(x[is.na(out)]), collapse = ", "))
    out
  }
  pc <- tab10::pc4[match(data$pc4, tab10::pc4$pc4), ]
  sted <- c("Zeer sterk stedelijk", "Sterk stedelijk", "Matig stedelijk",
            "Weinig stedelijk", "Niet stedelijk")[pc$urb]
  corop <- as.character(pc$COROP)
  agem <- suppressWarnings(as.numeric(data$agem))
  agem[is.na(agem)] <- 32
  lp <- b$Gewicht[b$Voorspeller == "Intercept"] +
    w("Geslacht", data$sex) +
    w("# vroeggeboorten 24-37w", data$n_vroeg) +
    w("In voorafgaande zwangerschap", data$vooraf_vroeg) +
    w("# voorafgaande SGA", data$n_sga) +
    w("SGA voorafgaande zwangerschap", data$vooraf_sga) +
    w("Interpregnantie interval", data$interpreg) +
    w("Amenorroeduur bij start", data$amd) +
    w("Graviditeit", data$grav) +
    w("Opleiding vader", data$eduf) +
    w("Leeftijd vader", data$agef_cat) +
    w("Opleiding moeder", data$edum) +
    b$Gewicht[b$Voorspeller == "Leeftijd moeder"] * agem +
    w("Rol moeder in huishouden", data$plhh) +
    w("Besteedbaar inkomen", data$income) +
    w("Woningbezit", data$house) +
    w("Stedelijkheid", sted) +
    w("COROP", corop)
  p <- expit(lp)
  data.frame(data, lp = lp, p = p, rank = p2rank(p, "preterm-32w"))
}
```

Voorbeeld:

``` r
d <- data.frame(
  sex = c("Jongen", NA, "Meisje"),
  n_vroeg = c("0", NA, "2"),
  vooraf_vroeg = c("Nee", NA, "Ja"),
  n_sga = c("0", NA, "1"),
  vooraf_sga = c("Nee", NA, "Ja"),
  interpreg = c("18-24 maanden", NA, "<6 maanden"),
  amd = c("0-70 dagen", NA, ">112 dagen"),
  grav = c("2", NA, "4"),
  eduf = c("HBO, WO", NA, "VMBO"),
  agef_cat = c("31-35", NA, "21-25"),
  edum = c("HBO, WO", NA, "MBO 2"),
  agem = c(31, NA, 22),
  plhh = c("Partner met kind", NA, "Alleenstaand met kind"),
  income = c("Hoog", NA, "Bestaansminimum"),
  house = c("Eigen woning", NA, "Huurwoning met huurtoeslag"),
  pc4 = c(3511, NA, 1102))

predict_preterm(d)[, c("lp", "p", "rank")]
#>         lp           p      rank
#> 1 -6.51329 0.001481393  3.197111
#> 2 -5.92596 0.002662138 24.195231
#> 3 -1.46013 0.188447443 99.973188
```

Rij 2 (alles onbekend) laat het risico zien dat de app toont als er niets is ingevuld.

**Data in CBS-codering.** Brondata in de codering van het oorspronkelijke model (bijv. `geslmannelijk`, `grav_cat`) moet je eerst omzetten naar de `Categorie`-labels. Gebruik daarvoor de kolom `Modelterm` in `tab10::betas`.

**Overeenkomst met de app.** Tot en met versie 1.2.1 telde de app het gewicht van het interpregnantie-interval twee keer op (#6). Sinds 1.2.2 geeft deze functie hetzelfde resultaat als de app.

## 5. Toepassen op individuele data via JAMES

### Dataflow

1.  **jamesapp** (of een andere client) roept `james::request_tab10()` aan, of `POST /tab10/request/json`, met BDS-JSON (`txt`) of een bestaande `session`. JAMES slaat de data op en geeft een URL terug: `https://<host>/tab10/?session=<key>`.
2.  **tab10** (`shiny/app_james.R`) leest de parameter `session` uit de URL ([shiny/app_james.R:971-994](../shiny/app_james.R#L971-L994)).
3.  `fetch_james_session()` ([shiny/app_james.R:102-113](../shiny/app_james.R#L102-L113)) haalt `GET {JAMES_BASE_URL}/{session}/rda` op. Dat levert een `.RData` met `.val` = `list(psn = ..., xyz = ...)` (het `bdsreader`-formaat). De standaardwaarde van `JAMES_BASE_URL` is `http://james` (Docker-netwerk).
4.  `bdsmodels::collect_predictors(child_data, purpose = "tab10")` zet het dossier om naar `list(psn = <1 rij>, tv = <groeitabel>)`.
5.  Een `observe()`-blok ([shiny/app_james.R:1067-1115](../shiny/app_james.R#L1067-L1115)) vult de inputvelden met `updateSelectInput()` / `updateTextInput()`.
6.  De reactives uit §3 berekenen `preterm_risk()` opnieuw. Daarna tekent `create_tab10()` de Tafel van Tien. De gebruiker kan ontbrekende velden handmatig aanvullen.

Lokaal testen zonder jamesapp:

``` r
url <- james::request_tab10(
  txt = system.file("examples/maria.json", package = "bdsreader"),
  sitehost = "http://localhost:8080",
  tab10host = "http://localhost:3838")
url   # open in de browser
```

### Wat JAMES nu vult voor vroeggeboorte

Van de 17 voorspellers worden er via JAMES **maar 2** automatisch gevuld:

| Voorspeller | Bron in `psn` | Opmerking |
|------------------------|------------------------|------------------------|
| Geslacht (`sex_pt`) | `sex` | Geslacht van het kind. Bij 16–20 weken meestal nog onbekend. |
| Leeftijd moeder (`mother_age_pt`) | `agem` | `collect_predictors` gebruikt `agem - 1`, ongeveer de leeftijd bij conceptie. |

Alle andere velden blijven op "Onbekend" en krijgen dus het gewicht uit de kolom *Bij onbekend* in §2. Wil je meer automatisch vullen, dan zijn deze stappen nodig:

- **Postcode → stedelijkheid/COROP.** `psn$pc4` is beschikbaar, maar wordt nu alleen naar `pc4` (overgewicht) geschreven. Voeg toe: `updateNumericInput(inputId = "pc4_pt", value = current.target()[["psn"]][["pc4"]])`.
- **Opleiding ouders.** `collect_predictors` levert `eduf`/`edum` in de overgewicht-indeling ("Geen, Basis", "VMBO-P", …). Het vroeggeboortemodel gebruikt een andere indeling ("Basis", "VMBO", "MBO 2", …). Daarvoor is een mapping vanuit de BDS-codes nodig.
- **Obstetrische voorgeschiedenis** (graviditeit, eerdere vroeggeboorte/SGA, interpregnantie-interval, amenorroeduur) en **sociaaleconomische velden** (huishouden, inkomen, woningbezit). Die zitten nog niet in `collect_predictors`. Daarvoor moeten BDS-elementen (of nieuwe elementen) worden vastgesteld en in `bdsmodels` worden toegevoegd.

## 6. Bekende problemen en open punten

1.  **Interpregnantie-interval dubbel geteld (opgelost in 1.2.2, #6).** In `preterm_risk()` stond `interpreg_cat_pt_beta() + interpreg_cat_pt_beta()`, in alle drie de apps. Bij "Onbekend" verlaagde dit de lineaire predictor met 0,335 extra, waardoor de odds ongeveer 28 % te laag uitkwamen.
2.  **"Onbekend" bij opleiding** krijgt het gewicht van HBO/WO, het laagste risico. Kies bewust: liever de referentie, of een gemiddelde.
3.  **Eerste zwangerschap.** Hoe codeer je een nullipara consistent? Door de collineaire `nvt`-termen is dit niet eenduidig. Advies: gebruik `# voorafgaande SGA = "nvt"` en `Interpregnantie interval = "nvt"`, en laat bij de vroeggeboorte-items `"0"` / `"Ja"` (gewicht 0) staan. Laat dit bevestigen door de modelbouwer.
4.  **Bug in `bdsmodels::collect_predictors`** (purpose `"tab10"`): `edum` wordt afgeleid uit `p$eduf` in plaats van `p$edum`. Dat raakt nu alleen het overgewichtmodel, maar wel zodra opleiding moeder ook voor vroeggeboorte wordt gevuld.
5.  **Geen pakketfunctie.** De berekening staat drie keer gekopieerd in de Shiny-apps. Een functie `predict_preterm()` in `R/` (zoals in §4) voorkomt afwijkingen tussen de apps.