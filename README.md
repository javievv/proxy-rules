# proxy-rules

自用的代理分流规则，主要在 Quantumult X 上使用。

| 内容 | Quantumult X | 通用格式 | 建议策略 |
|---|---|---|---|
| 香港银行：中银香港、汇丰、恒生、众安等 | [`quantumultx/hk-bank.list`](quantumultx/hk-bank.list) | [`rules/hk-bank.txt`](rules/hk-bank.txt) | 直连 |

`rules/*.txt` 是源文件；`quantumultx/*.list` 由 `scripts/build.sh` 生成，不要手改。

## 使用

### Quantumult X

在 App 里添加：设置 → 分流 → 引用（右上角）→ 添加。资源路径填下面的地址，标签随便起，策略偏好选「直连」。添加后把它拖到引用列表的最上面。

```
https://raw.githubusercontent.com/javievv/proxy-rules/main/quantumultx/hk-bank.list
```

也可以直接写进配置文件的 `[filter_remote]`，放在第一行：

```
https://raw.githubusercontent.com/javievv/proxy-rules/main/quantumultx/hk-bank.list, tag=香港银行, force-policy=direct, update-interval=86400, opt-parser=false, enabled=true
```

### 其他客户端

`rules/*.txt` 每行一条规则，不带策略，可用于 mihomo（Clash Meta）的 `classical` + `text` 规则集，以及 Surge、Loon、Shadowrocket 的 `RULE-SET`。

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

只改 `rules/*.txt`，改完运行下面两个脚本再提交。`check.sh` 通过 Google DoH 确认域名存在，可以绕开本机的 fake-ip DNS；`build.sh` 重新生成 Quantumult X 文件。

```bash
scripts/check.sh && scripts/build.sh
```

补充新域名最可靠的办法：打开代理客户端的连接日志，把 App 的登录、转账等流程走一遍，看哪些请求还在走代理。

## 参考

- [Accademia/Additional_Rule_For_Clash](https://github.com/Accademia/Additional_Rule_For_Clash) `Bank/BankHK.yaml`
- [klchai/personal-rule](https://github.com/klchai/personal-rule) `HK_Bank`
- [blackmatrix7/ios_rule_script](https://github.com/blackmatrix7/ios_rule_script) `BOC`
