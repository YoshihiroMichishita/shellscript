思想として、
- コードを保管するディレクトリと数値計算結果を格納するディレクトリは分けた方が良い。
- 数値計算結果を保管するディレクトリに、実行ファイルと実行パラメータのファイルも保管しておいた方が後々どういう計算だったか分かりやすい
という２点の下に作ってあります。
中身でやっている事としては、
1. 計算結果を格納する./Data/${dir}(ディレクトリの名前にはパラメータ等を付けておく。例えばdir=Phase_T001_H008)というディレクトリを作る。ここでディレクトリ名にはパラメータの値を付けておくと後で分かりやすい。(僕の場合は日付も入れてます)
2. ./Data/${dir}/の中に実行するファイル(~.jl)をコピーする。(こうしておくと、コードを保管するディレクトリとは別に、当時の実行ファイルが保存されるので混乱が起きにくい。コードは日々書き換わるものなので、、)
3. ./Data/${dir}/の中に実行するjob.shファイルを作成する。(cat >> 以下)これでさらにディレクトリの中に当時実行したパラメータの情報も入る。
そこのディレクトリからjobを投げる
って感じです。多分一番いい感じでデータが整理できます。

ちなみに計算結果の回収にはWSLを入れている人、もしくはMacを使用している人なら「rsync」というコマンドが便利です。
例えば、
rsync -r -av michishita@192.xxx.xxx.xx:./Data/ /home/ymichishita/Data/
とlocal(自分の)PCで打つと、計算機の中の./Data/以下の中身を、localのPCの~/Data/以下に同期してくれます。便利です。
ちなみに僕はコードファイルを転送する時にもこれを使ってます。例えばこんな感じ。
rsync -av -r ./julia/ michishita@192.xxx.xxx.xx:./julia/