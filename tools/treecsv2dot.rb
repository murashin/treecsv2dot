#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# 
# Copyright 2010-2012 Shin-ya Murakami <murashin _at_ gfd-dennou.org>
#
# ツリー構造を表現したcsvファイルからdotファイルを構成するスクリプト.
#
# ver 0.1.3
# 
#
# dotファイルはDOT言語で書かれたファイルのこと. 
# graphvizがこれを解釈し, グラフに変換する. 
# graphvizおよびDOT言語に関しては以下のURLを参照のこと.
#    - 公式サイト http://www.graphviz.org/
#    - 日本語チュートリアル http://homepage3.nifty.com/kaku-chan/graphviz/
#
# csvファイルの形式:
#    - 値がコンマを含む場合は値を""で囲む.
#      このときコンマと値の間に空白を入れないこと
#    - 値は"を含まないと仮定する.
#    - csvファイルはUTF-8である
#    - 先頭に # はコメント行を表す
#    - 空白のみの行は読み飛ばされる
#    - ある位置から行末まで, 空要素が続く場合は読み飛ばされる
#    - ファイル先頭から見て, 最初のゼロでない最前列要素をタイトルとみなす.
#
# 例:
#   ----ここから----
#   テスト              <- タイトル
#   
#   a,b,c,d
#    , , ,e
#    , ,f,g
#    ,h,i
#   j,k
#    ,l,m
#   ----ここまで----
# これは, 次のようなツリー構造を表す
#
#    a -- b -- c -- d
#          \    \
#           \    -- e
#            - f -- g
#    j -- k
#     \
#      -- l -- m
#

require 'csv'

# 設定
$id_prefix = 'id' # nodeのシンボルのprefix
$id_digits = 4    # nodeの数の桁数

# 値に現れる " のエスケープ
def escape_dq(str)
  str.gsub(/"/,'\"')
end

# nodeのシンボルを定義
def id(nid)
  "#{$id_prefix}#{nid.to_s.rjust($id_digits,'0')}"
end

# nodeを定義する出力
def define_node(nid, label)
  print "  #{id(nid)} [ label = \"#{escape_dq(label)}\" ];\n"
  nid = nid + 1
end

# node間の関係を定義する出力
def define_relation(id_a, id_b)
  print "  #{id(id_a)} -- #{id(id_b)};\n"
end

# ヘッダとフッタの定義
def print_header(title)
  print <<EOS
graph generated_data {
  // 全体設定 //
  graph [ // fontname = "Helvetica-Oblique",
	  label = "\\n#{escape_dq(title)}",
	  rankdir = LR ];
  node [ shape = box ];
EOS
end

def print_footer()
  print <<EOS
}
EOS
end

# 引数チェック
inputfile = ARGV[0]
if inputfile.nil?
  print "error: need an argument of input file."
end

# メインの処理
nid = 0          # 何番のidまで使ったかを表す数
is_first_line = true

# pathは, CSVファイルの中身が表現しているtree構造において, 
# rootから, あるbranch/leafまでのnodeを順に並べた配列である. 
path = Array.new

if RUBY_VERSION >= '1.9.0'
  csv = CSV.read(inputfile, :encoding => "UTF-8")
else
  csv = CSV.read(inputfile)
end

csv.each do |l|
  next if l.compact.size == 0          # 空行の読み飛ばし
  if not l.compact.first.nil?
    next if /^#/ =~ l.compact.first.strip  # コメント行の読み飛ばし
  end
  
  # 最初に登場するゼロでない要素をタイトルとする
  if is_first_line
    title = l.compact.first
    print_header title      # ヘッダを出力
    is_first_line = false
    next
  end
  cur = 0  # path配列において注目するインデックスの位置
  
  l.each do |n|
    n.strip! if not n.nil?  # 前後の空白を除去
    unless n.nil? || n.empty?
      # path配列の, indexがcur以降の要素を削除
      path = ( cur == 0 ? [] : path[0..cur-1] )
      path.push nid             # pathの末尾にnidを追加
      nid = define_node(nid, n) # 機材の定義
      if path.size > 1
        # path配列の要素が2個以上の場合は, 関係を定義
        define_relation(path[-2],path[-1])
      end
    end
    cur = cur + 1 #現在位置更新
  end
end
print_footer
