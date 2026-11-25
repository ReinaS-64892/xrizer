# Frame 実験ブランチ

`experiment/frame-rs-main` は `ImSapphire/frame` の上に `rs-main` の独自変更を
積んだブランチです。最初の取り込み元は
`de47f96fec2feb775e843e09c9c4695ef4d84aa0`、元の `rs-main` は `67a6880` です。
Frame 対応に加え、近接センサー、トラッカーの hotplug、Lighthouse 基地局の除外、
ゲーム用 pose の予測制限を含みます。

## frame の更新・force push 後の載せ直し

作業ツリーをコミットまたは stash してから、xrizer 内で実行します。

この作業ディレクトリの直下（WiVRn と xrizer が並ぶ場所）では、
`./refresh-xrizer-frame.sh` で実行できます。競合時も
`./refresh-xrizer-frame.sh --continue`、`./refresh-xrizer-frame.sh --abort` を使えます。

```bash
git switch experiment/frame-rs-main
bash tools/refresh-frame.sh
```

ローカルでは `git refresh-frame` という alias でも実行できます。
このスクリプトは明示的に `ImSapphire/frame` を fetch し、
`experiment/frame-base` より上の独自コミットだけを `rebase --onto` します。
新しい clone で base ブランチがなければ、最初の取り込み元を使います。
更新済み履歴を別の clone に渡す場合は、実験ブランチと一緒に
`experiment/frame-base` も渡してください。

載せ直す直前に `backup/frame-refresh/<UTC日時>-<PID>` を作るので、旧 frame と
独自変更の両方が残ります。成功した場合だけ `experiment/frame-base` を進めます。
force push された履歴を通常の merge や `git pull` で取り込まないでください。

競合した場合は編集・`git add` 後に次を実行します。

```bash
bash tools/refresh-frame.sh --continue
```

取り消す場合は次を使います。

```bash
bash tools/refresh-frame.sh --abort
```

ローカルの `rerere.enabled=true` により、今後解消する競合を記録・再利用します。
再利用した結果も確認してください。初回の frame 先端は
`experiment/frame-initial-20261125` タグにも保存しています。
元の `rs-main` は変更しません。push は自動実行しません。

## rs-main 側にも変更が増えた場合

このスクリプトは frame 側の更新用です。rs-main 側の新しいコミットは、
重複を確認した上でこの実験ブランチに cherry-pick してください。
