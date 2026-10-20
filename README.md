# proxy-rules

自用的代理分流规则。每行一条规则，不带策略，可以直接用于 mihomo（Clash Meta）的 `classical` + `text` 规则集，以及 Surge、Loon、Shadowrocket 的 `RULE-SET`。

| 文件 | 内容 | 建议策略 |
|---|---|---|
| [`rules/hk-bank.txt`](rules/hk-bank.txt) | 香港银行：中银香港、汇丰、恒生、众安等 | `DIRECT` |

## 使用

mihomo：

```yaml
rule-providers:
  hk_bank:
    type: http
    behavior: classical
    format: text
    url: https://raw.githubusercontent.com/javievv/proxy-rules/main/rules/hk-bank.txt
    path: ./ruleset/hk_bank.txt
    interval: 86400

rules:
  # 放在代理规则集（如 global）之前
  - RULE-SET,hk_bank,DIRECT
```

Surge / Loon / Shadowrocket：

```
RULE-SET,https://raw.githubusercontent.com/javievv/proxy-rules/main/rules/hk-bank.txt,DIRECT
```

## 维护

添加或修改规则后运行检查。脚本通过 Google DoH 确认域名存在，可以绕开本机的 fake-ip DNS：

```bash
scripts/check.sh
```

补充新域名最可靠的办法：打开代理客户端的连接日志，把 App 的登录、转账等流程走一遍，看哪些请求还在走代理。

## 参考

- [Accademia/Additional_Rule_For_Clash](https://github.com/Accademia/Additional_Rule_For_Clash) `Bank/BankHK.yaml`
- [klchai/personal-rule](https://github.com/klchai/personal-rule) `HK_Bank`
- [blackmatrix7/ios_rule_script](https://github.com/blackmatrix7/ios_rule_script) `BOC`
