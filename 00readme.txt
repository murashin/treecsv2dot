treecsv2dot version 0.1.3: 2012/02/19

treecsv2dot converts csv file with a tree-like format to dot file

treecsv2dotは、CSV(comma separated value)ファイルからツリー構造を表現する
DOTファイルを生成する ruby スクリプトです。
デフォルトでpngフォーマットの画像ファイルを出力するようなMakefileが付属しています。

与えるCSVファイルには特定の構造を仮定します。
具体的には tools/treecsv2dot.rb のヘッダをご覧下さい。

treecsv2dot.rbは、以下のコマンドを使用します。

- GNU make
- rm
- ruby 1.8/1.9
- dot (graphvizに付属。2.28.0で動作確認)

開発者の環境はFreeBSD 9.0-RELEASE(2012/02/20時点)です。

ライセンスは、2条項BSDライセンス(BSD 2-Clause license)です(LICENSE参照)。

何かあれば、村上真也 murashin _at_ gfd-dennou.org までお問い合わせ下さい。
