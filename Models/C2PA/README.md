Roles:
- Generating Product (GP)
- Verifying Product (VP)
- CertInit
- TSA

Variables:
- Names(gp, ci, tsa)
- PixelData(data)
- GenericAssertions(assertions)

Functions:
- pk(name), returns public key for `name`
- sk(name), returns private key for `name`
- e[msg, k], returns encryption of `msg` under `k`
- h(msg), returns hash digest of `msg`

[Optional] CertInit -> GP: sk(gp)

[Optional] CertInit -> All: gp||pk(gp)||e[h(gp||pk(gp)), sk(ci)]

GP -> TSA: h("claim"||h(data)||assertions)

GP <- TSA: ts||e[h(h("claim"||h(data)||assertions)||ts)), sk(tsa)]

GP -> VP: data||assertions||e[ts||e[h(h("claim"||h(data)||assertions)||ts)), sk(tsa)], sk(gp)]
