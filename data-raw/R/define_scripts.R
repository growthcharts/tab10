## Defines scripts

script_overweight_4y_2 <- tibble::tibble(
  name = "overweight-4y-2",
  outcome = "overweight-4y",
  version = "2",
  language = "nl",
  frame = seq(8),
  framename =
    c("intro", "klas", "risico", "groep", "hoog", "kind", "uitslag",
      "vervolg"),
  frameshow = rep(TRUE, 8),
  frametext = c(
    "We zien hier 100 cirkels. Elke cirkel staat voor één kind. Er \\
         zijn 15 cirkels met een oranje kleur. Dat zijn de kinderen die op \\
         4-jarige leeftijd <b>overgewicht</b> hebben. Bij sommige kinderen \\
         is overgewicht normaal, maar voor de meeste is het niet gezond. \\
         Uit onderzoek weten we dat kinderen met overgewicht op 4-jarige \\
         leeftijd als volwassene ook vaak te zwaar zijn.",
    "Hoe vaak komt overgewicht voor bij 4-jarige kinderen? Stel dat \\
         een schoolklas bestaat uit 25 kinderen. In een schoolklas zitten \\
         dan rond de 3 tot 4 kinderen met overgewicht.",
    "Kinderen verschillen in de kans op overgewicht. Er zijn kinderen \\
         met een laag risico, en kinderen met een hoger risico. De computer \\
         kan voor elk kind het risico berekenen. We gaan nu de 100 kinderen \\
         sorteren in <b>10 risicogroepen</b>.",
    "Geheel links staan de kinderen met het laagste risico. Alle cirkels \\
         in de kolom zijn groen, en geen van deze kinderen krijgt later \\
         overgewicht. Geheel rechts staan de kinderen met het hoogste risico. \\
         Van de 10 kinderen krijgen er 6 later overgewicht en 4 niet. Een \\
         hoog risico betekent dus niet automatisch dat overgewicht \\
         onvermijdelijk is; wel is de kans op later overgewicht aanzienlijk.",
    "Welke risico op overgewicht is acceptabel? Dat is voor iedereen \\
         verschillend, maar over het algemeen vinden we een kans van <b>3 \\
         of meer van de 10</b> hoog. In de figuur voldoen hieraan twee \\
         risicogroepen.",
    "<b>In welke groep zit uw kind?</b>",
    "Op basis van wat we nu weten zit uw kind in risicogroep \\
         <b>Hoog</b>. We kunnen niet met zekerheid zeggen of uw kind \\
         later daadwerkelijk overgewicht zal hebben. Wel is de kans groot. \\
         Van de 10 kinderen zijn er later 6 te zwaar.",
    "Het is mogelijk dat de gegevens in de computer onjuist of \\
         onvolledig zijn. Bent u bereid om met mij mee te kijken of \\
         de computer de juiste gegevens heeft gebruikt?"
  ))

script_overweight_4y_3 <- tibble::tibble(
  name = "overweight-4y-3",
  outcome = "overweight-4y",
  version = "3",
  language = "nl",
  frame = seq(8),
  framename =
    c("intro", "klas", "risico", "groep", "hoog", "kind", "uitslag",
      "vervolg"),
  frameshow = rep(TRUE, 8),
  frametext = c(
    "We zien hier 100 cirkels. Elke cirkel staat voor één kind. Er \\
         zijn <b>{{ncase}} cirkels met een {{case_color}} kleur</b>. \\
         Dat zijn de kinderen die op {{outcome_age}} leeftijd \\
         <b>{{aproblem}}</b> hebben. Bij sommige kinderen \\
         is {{aproblem}} normaal, maar voor de meeste is het niet gezond. \\
         Uit onderzoek weten we dat kinderen met {{aproblem}} op \\
         {{outcome_age}} leeftijd als volwassene ook vaak te zwaar zijn.",
    "Hoe vaak komt {{aproblem}} voor bij {{outcome_age}} kinderen? Stel dat \\
         een schoolklas bestaat uit 25 kinderen. In een schoolklas zitten \\
         dan <b>rond de {{approx}} kinderen met {{aproblem}}</b>.",
    "Kinderen verschillen in de kans op {{aproblem}} Er zijn kinderen \\
         met een laag risico, en kinderen met een hoger risico. <b>De app \\
         berekent voor elk kind het risico</b>. We sorteren nu de 100 kinderen \\
         in <b>10 risicogroepen</b>.",
    "Geheel <b>links</b> staan de kinderen met het <b>laagste</b> risico. \\
         Alle cirkels hebben een {{control_color}} kleur. Geen van deze \\
         kinderen krijgt later {{aproblem}. \\
         Geheel <b>rechts</b> staan de kinderen met het <b>hoogste</b> \\
         risico. Van de 10 kinderen krijgen er {{casecounts[10]}} \\
         later {{aproblem}} en {{controlcounts[10]}} niet. Een \\
         hoog risico betekent dus niet automatisch dat {{aproblem}} \\
         onvermijdelijk is; wel is de kans op later {{aproblem}} aanzienlijk.",
    "Welke risico op {{aproblem}} is acceptabel? Dat is voor iedereen \\
         verschillend, maar over het algemeen vinden we een kans van <b>3 \\
         of meer van de 10</b> hoog. In de figuur {{nriskgroup}}.",
    "<b>In welke groep zit uw kind?</b>",
    "Op basis van wat we nu weten zit uw kind in <b>risicogroep \\
         {{riskgroup}}</b>. We kunnen niet met zekerheid zeggen of uw kind \\
         later {{aproblem}} zal hebben. Wel is de kans daarop \\
         <b>{{riskgrouplabel}}</b>: <b>{{riskgrouptext}} van de 10 \\
         kinderen</b> uit risicogroep <b>{{riskgroup}}</b> heeft op \\
         {{outcome_age}} leeftijd {{aproblem}}.",
    "Het is mogelijk dat de gebruikte gegevens onjuist of \\
         onvolledig zijn. Bent u bereid om met mij mee te kijken of \\
         de app de correcte gegevens gebruikt?"
  ))

script_preterm_37w_1 <- tibble::tibble(
  name = "preterm-37w-1",
  outcome = "preterm-37w",
  version = "1",
  language = "nl",
  frame = seq(8),
  framename =
    c("intro", "klas", "risico", "groep", "hoog", "kind", "uitslag",
      "vervolg"),
  frameshow = rep(TRUE, 8),
  frametext = c(
    "We zien hier 100 cirkels. Elke cirkel staat voor één zwangerschap. Er \\
         zijn <b>{{ncase}} cirkels met een {{case_color}} kleur</b>. \\
         Dat zijn de zwangerschappen die eindigen met een \\
         <b>{{aproblem}}</b>, \\
         d.w.z., bij een zwangerschapsduur korter dan 37 volledige weken. \\
         Uit onderzoek weten we dat te vroeg geboren kinderen kwetsbaar \\
         zijn.",
    "Hoe vaak komt {{aproblem}} voor? Stel dat 25 zwangere vrouwen zich \\
         verzamelen in een schoolklas. In de schoolklas zitten \\
         dan <b>rond de {{approx}} vrouwen</b> waarvan de zwangerschap \\
         met een {{aproblem}} eindigt.",
    "Zwangerschappen verschillen in de kans op {{aproblem}}. Er zijn \\
         zwangerschappen met een laag risico, en zwangerschappen met een \\
         hoger risico. <b>De app berekent voor elke zwangerschap het \\
         risico</b>. We sorteren nu de 100 zwangerschappen \\
         in <b>10 risicogroepen</b>.",
    "Geheel <b>links</b> staan de zwangerschappen met het \\
         <b>laagste</b> risico. Alle cirkels hebben een {{control_color}} \\
         kleur. Geen van deze zwangerschappen eindigt in {{aproblem}. \\
         Geheel <b>rechts</b> staan de zwangerschappen met het <b>hoogste</b> \\
         risico. Van de 10 zwangerschappen eindigt er {{casecounts[10]}} \\
         met een {{aproblem}} en {{controlcounts[10]}} niet. Een \\
         hoog risico betekent dus niet automatisch dat {{aproblem}} \\
         onvermijdelijk is.",
    "Welke risico op {{aproblem}} is acceptabel? Gezien de ernst van de \\
         mogelijke gevolgen voor moeder en kind vinden we een kans van <b>1 \\
         op de 10</b> hoog. In de figuur {{nriskgroup}}.",
    "<b>In welke risicogroep valt uw zwangerschap?</b>",
    "Op basis van wat we nu weten behoort uw zwangerschap tot <b>risicogroep \\
         {{riskgroup}}</b>. We kunnen niet met zekerheid zeggen of uw \\
         kind te vroeg geboren zal worden. \\
         Wel is de kans daarop \\
         <b>{{riskgrouplabel}}</b>. Naar verwachting zal <b>{{riskgrouptext}} \\
         van de 10 zwangerschappen</b> uit risicogroep <b>{{riskgroup}}</b> \\
         eindigen met een {{aproblem}}.",
    "Het is mogelijk dat de gebruikte gegevens onjuist of \\
         onvolledig zijn. Bent u bereid om met mij mee te kijken of \\
         de app de correcte gegevens gebruikt?"
  ))

scripts <- dplyr::bind_rows(
  script_overweight_4y_3,
  script_overweight_4y_2,
  script_preterm_37w_1
)

scripts$frametext <- unlist(lapply(scripts$frametext, stringr::str_glue))
usethis::use_data(scripts, overwrite = TRUE)
