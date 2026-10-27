# proxy-rules

自用的代理分流规则，主要在 Quantumult X 上配合资源解析器使用。

| 文件 | 内容 | 建议策略 |
|---|---|---|
| [`rules/hk-bank.txt`](rules/hk-bank.txt) | 香港银行：中银香港、汇丰、恒生、众安等 | 直连 |
| [`rules/apple-intelligence.txt`](rules/apple-intelligence.txt) | Apple Intelligence、ChatGPT 扩展、Siri | 美国节点（香港不可用），放在 Apple 直连规则之前 |

下面以 `hk-bank.txt` 为例，其他规则把地址和策略换掉即可，例如：

```
https://raw.githubusercontent.com/javievv/proxy-rules/main/rules/apple-intelligence.txt
```

规则采用通用写法：每行一条 `DOMAIN` / `DOMAIN-SUFFIX`，不带策略。

## 使用

### Quantumult X（需要开启资源解析器）

设置 → 分流 → 引用（右上角）→ 添加：资源路径填下面的地址，策略偏好选「直连」，打开「资源解析器」。添加后把它拖到引用列表的最上面。

```
https://raw.githubusercontent.com/javievv/proxy-rules/main/rules/hk-bank.txt
```

写进配置文件的话，加在 `[filter_remote]` 的第一行：

```
https://raw.githubusercontent.com/javievv/proxy-rules/main/rules/hk-bank.txt, tag=香港银行, force-policy=direct, update-interval=86400, opt-parser=true, enabled=true
```

### 其他客户端

Surge / Loon / Shadowrocket：

```
RULE-SET,https://raw.githubusercontent.com/javievv/proxy-rules/main/rules/hk-bank.txt,DIRECT
```

mihomo（Clash Meta）：

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
  - RULE-SET,hk_bank,DIRECT
```

## 维护

修改规则后运行检查。脚本通过 Google DoH 确认域名存在，可以绕开本机的 fake-ip DNS：

```bash
scripts/check.sh
```

补充新域名最可靠的办法：打开代理客户端的连接日志，把 App 的登录、转账等流程走一遍，看哪些请求还在走代理。

## 参考

- [Accademia/Additional_Rule_For_Clash](https://github.com/Accademia/Additional_Rule_For_Clash) `Bank/BankHK.yaml`
- [klchai/personal-rule](https://github.com/klchai/personal-rule) `HK_Bank`
- [blackmatrix7/ios_rule_script](https://github.com/blackmatrix7/ios_rule_script) `BOC`
