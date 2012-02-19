# 
# Copyright 2010-2012 Shin-ya Murakami <murashin@gfd-dennou.org>
#
# ツリー構造を表現するCSVファイルから画像を生成するためのMakefile
# 

# 出力フォーマットの選択
#FMT=	gif
#FMT=	pdf
FMT=	png

# 使うプログラムのパス(以下ではパスが通っていると仮定)
RM=		rm
NKF=		nkf
RUBY=		ruby
DOT=		dot
TREECSV2DOT=	../tools/treecsv2dot.rb

# 対象ファイル名
FILES=	kizai-1

# 
# 以下は変更しないこと.
#
%.dot : %.csv
	${NKF} -S -w $< > $<.tmp
	${RUBY} ${TREECSV2DOT} $<.tmp > $@
	${RM} -f $<.tmp
%.${FMT} : %.dot
	${DOT} -T${FMT} $< -o $@

all: $(patsubst %,%.$(FMT),$(FILES))

clean:
	${RM} -f *.dot *.gif *.png *.pdf *.csv.tmp *~
