/// Enum for language codes to provide type safety
enum LanguageCode {
  ab, aa, af, ak, sq, am, ar, an, hy, as, av, ae, ay, az, bm, ba, eu, be, bn, bh,
  bi, nb, bs, br, bg, my, ca, km, ch, ce, ny, zh, zh_Hans, zh_Hant, cu, cv, kw,
  co, cr, hr, cs, da, dv, nl, dz, en, eo, et, ee, fo, fj, fi, fr, ff, gd, gl, lg,
  ka, de, el, gn, gu, ht, ha, he, hz, hi, ho, hu,  io, ig, id, ia, ie, iu, ik,
ga, it, ja, jv, kl, kn, kr, ks, kk, ki, rw, ky, kv, kg, ko, kj, ku, lo, la, lv,
li, ln, lt, lu, lb, mk, mg, ms, ml, mt, gv, mi, mr, mh, mn, na, nv, nd, nr, ng,
ne, se, no, nn, oc, oj, or, om, os, pi, pa, fa, pl, pt, ps, qu, ro, rm, rn, ru,
sm, sg, sa, sc, sr, sn, ii, sd, si, sk, sl, so, st, es, su, sw, ss, sv, tl, ty,
tg, ta, tt, te, th, bo, ti, to, ts, tn, tr, tk, tw, ug, uk, ur, uz, ve, vi, vo,
wa, cy, fy, wo, xh, yi, yo, za, zu
}

/// Extension to convert enum to string and back
extension LanguageCodeExtension on LanguageCode {
  String get code => toString().split('.').last;

  static LanguageCode fromString(String code) {
    return LanguageCode.values.firstWhere(
          (e) => e.code == code,
      orElse: () => LanguageCode.en,
    );
  }
}