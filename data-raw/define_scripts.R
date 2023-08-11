## Defines scripts

scripts <- tibble::tibble(
  name = "overweight-4y-2",
  outcome = "overweight",
  language = "nl",
  version = "2",
  framenum = seq(8),
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
scripts$frametext <- unlist(lapply(scripts$frametext, stringr::str_glue))
usethis::use_data(scripts, overwrite = TRUE)

