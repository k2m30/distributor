Feature: update prices
  As user
  I want my sites update prices successfully
  In order to work

  @outline
  Scenario Outline: user starts updating prices
    Given user is test_user
    When my <site> updates
    Then it is updated properly
  Examples:
    | site               |
#    | 21vek.by           |
    | 24real.by          |
#    | 24shop.by          |
#    | 360.shop.by        |
#    | 50.by              |
#    | 7sotok.by          |
#    | agro-shop.by       |
#    | amd.by             |
#    | antamedia.by       |
#    | belmall.by         |
#    | bes.shop.by        |
#    | bez-nal.by         |
#    | bikord.of.by       |
#    | camera.shop.by     |
#    | clean.by           |
#    | cleanhouse.by      |
#    | delomastera.by     |
#    | dvrka.by           |
#    | elmarket.by        |
#    | extrastore.by      |
#    | fazenda.shop.by    |
#    | gepard.by          |
#    | golden.by          |
#    | k-center.by        |
#    | karcher-belarus.by |
#    | kosilka.by         |
#    | krama.by           |
#    | mir-karcher.by     |
#    | mir-mtd.by         |
#    | mirbt.by           |
#    | mirtehniki.by      |
#    | motoblok.by        |
#    | multicom.by        |
#    | nash-dom.shop.by   |
#    | nextshop.by        |
#    | nvd.by             |
#    | orion.shop.by      |
#    | papa-karlo.shop.by |
#    | pcbox.by           |
#    | pingvin.shop.by    |
#    | premium.shop.by    |
#    | pro-karcher.by     |
#    | radiomarket.by     |
#    | rodnoi.by          |
#    | rsmarket.by        |
#    | slavno.by          |
#    | star-sys.shop.by   |
#    | stroitel.shop.by   |
#    | suseki.by          |
#    | svoiludi.by        |
#    | technostil.by      |
#    | torgsin.shop.by    |
#    | ttn.by             |
#    | udachno.by         |
#    | upgrade.by         |
#    | vitrina.shop.by    |
#    | ydachnik.by        |
#    | zeta.by            |
