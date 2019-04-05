KMC Esolang battle 第0回 Writeup
====

KMCでのEsolang大会のログです。
システムを開発してくださったhakatashiさんに感謝。

問題・解説
----
http://esolang-0.wass80.xyz/contests/komabasai2018-day1/rule/

統計
----

後で書く．

言語ごとの解説
----
### Brainfuck (esotope) (170B, prime)
```
>>>++[-<<,<,>>,[<-----<----->>-]<++[<++++++++++>-]>>[>+<-]>]++<<<++++++++++[>++++>+>+++<<<-]>++.<<[>+>.<<-]>[<+>-]<<[>>>.>.<.<<[>+>>>.<<<<-]>[<+>-]<<-]>>>.>.<.<<+[>>.<<-]
```
入力はループを2回回して取る。必ず2桁なのでだいぶ楽。
48,50を引くのに改行コードの10を活用する
アスタリスク、スペース、改行は最初にまとめて作っておく
値をコピーしつつ出力すると出力ループを短く書ける

### Piet (254B, @dnek_)
#### 原寸
![original](https://i.imgur.com/ksojput.png)
#### 10x
![10x](https://i.imgur.com/quaXsv3.png)

- **左上** (入力-2)(=h-2)と入力(=w)をpush
- **右上** `"*"`をw回作って出力
- **右中** 改行出力
- **右下** `"*"`出力
- **中下** `" "`をh-2回作って出力
- **中ちょい下** `"*"`と改行出力
- **中ちょい右** hをデクリメントして0かどうか判定
- **中ちょい上** 技巧的pointing
- **左中** `"*"`をw回作って出力
- **中ちょい左上** 終了処理

詳しくは私が開発しているクロスプラットフォームIDEの[Pietron](https://github.com/dnek/pietron)を使って確認して欲しい。
また、仕様は[こちらのスライド](https://www.slideshare.net/KMC_JP/piet-80098546)がわかりやすい。

ちなみにPiet golfには大きく分けて2種類ある。
1つは抽象的なサイズ（codel数や対角線の長さ）を競うもので、もう1つは今回のようにバイナリサイズを競うものである。
バイナリサイズを競う場合は`optipng`するのを忘れないように。
また、詳しくは知らないがpng圧縮の都合上なるべく横に同じ色が続くようにすると良い気がする。
特にpushに用いないカラーブロックを延ばしたりポインターに影響のない白ブロックを黒ブロックにしたりすると効果があるかもしれない。
今回のコードではそれで2bytes減らすことができた。
また今回は関係なさそうだが、Pietインタプリタとして通常用いられる[npiet](https://www.bertnase.de/npiet/)はpngの他にgifと[ppm](https://ja.wikipedia.org/wiki/PNM_(%E7%94%BB%E5%83%8F%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%83%E3%83%88))にも対応している。
サイズが十分に小さい場合はppmのバイナリエンコーディングを使ってみると良いかもしれない。

### Befunge-98 (47B, satos&yamunaku)
```
&&:v,"*"<
7*,>1-:#^_"*",$a,\1-:!#@_:1\g60p\:1-6
```
gでy,xを順にpopして、位置(x,y)にある文字を取得しpushする。
pでy,x,vを順にpopして、vを文字として位置(x,y)に配置する。
位置は0-indexedで考えている。
何もない位置でgをすると空白を取得することが確かめられた。
hを減らしていくループ内で、位置(1,h)にある文字を取得すると、h>1のときは空白' '、h==1のときは'\*'を取得することになる。
これを(6,0)に配置することで、出力の各行の両側の'\*'を除いた部分を条件分岐なしで出力できる。

### Perl6 (54B, hanazuki)
```
$_=get;say $!="*"x($/=get),"
","*{" "x$/-2}*
"x$_-2,$!
```
Perl 6では，Perl 5とは違ってレキシカル変数は必ず`my`で宣言しなければならないが，`$_`，`$/`，`$!`の3つは勝手に使ってもよい（もちろん本来の用途で上書きされるので気をつける必要はある）．`-`の優先順位が`x`より高いのはPerl 5と違うところ．

### Evil (125B, siotouto)
```
ruulraaclrvruuclraaaclmxopojlalusbopojlalusbvukxsbrkhvhaeeeeeknmvavusbgwpmvwvusbnvwvmxhvwvhpjutnvwvsbnvwvooluyiixsblhamvwvusb
```
- ruulraaclrvruuclraaacl 入力を車輪Wと五輪Pに突っ込む("ab\ncd" -> [a-2,b+2,c-2,d+3],[10,0,0,0,0])
- mxopo mはラベル,xは次のgoto先をm<->jで切り替える, 車輪からcをレジスタにコピー
- jlalusb while(W[2]--)W[3]++; 結果としては　W[3]+=W[2];
- opo 同様に
- jlalusb W[1]+=W[0];
- vukxsb 車輪から10を引っ張ってきてデクリメントしてgoto先をmに切り替えてループ。つまり上のmとの間を10回やる
- TIPS: 256でオーバーフローするので、`(a-'0')*10+(b-'0')=a*10+b-16=(a-2)*10+(b+4)`
- これによって車輪は[a-2,H-2,c-2,W-1]になる
- rkhvhaeeeeekn 最後の改行の10と、bitを"02467531"の位置に動かす(>>>)eを用いて 五輪に[10,42,32,0,0]を代入する
- mvavusb (上の続き。足す処理をループで行っている)
- gwp gで五輪から`*`をもってきてwで出力,次のW-1個をループで出力するためにW-1を車輪からレジスタにコピー
- mvwvusbnvwv `*`を出力して、レジスタをデクリメントを繰り返す。五輪をずらして改行を出力。
- mxhvwvhp 二重ループなのでmでラベルをはってxで切り替える、`*`を出力してW-1を持ってくる
- jutnvwvsb 残りループ数をデクリメントして0（最後の一周）なら五輪を32から42にずらす、空白と最後の`*`を出力する
- nvwvooluyiixsb 五輪から改行コードを持ってきて、H-2からデクリメントし、0でなければループする
- lha W-1を持ってきてインクリメントする
- mvwvusb W個の`*`を出力する

### Emojicode 0.9.0 (168B, murata)
```
🏁🍇🕴🐇💻🍪🔤perl -e'$h=🔤🆕🔡👂🏼❗️🔤-2;print$a="*"x($w=🔤🆕🔡👂🏼❗️🔤),$/,("*",$"x($w-2),"*
")x$h,$a'🔤🍪❗️🍉
```
Emojiは大体4Byte (👂🏼に至っては8Byte!)も掛かってしまうので、素直にEmojiでコードを書くのは損です。
この言語は無駄に高機能で 🕴🐇💻 でsubshellを実行できるため、EmojiではなくASCIIを、つまりはshellを書きましょう。
このコンテストでは、開催者がEmojicode ver0.9.0をインストールする際のDockerイメージをubuntuにしたため、他のalpaneの言語系と異なり perl を実行できました。
つまりEmojicodeは実質 perl なのでした。
perlが使えない場合はgccやbashを使えばいいと思います。
(Emojiを真面目に書いた場合は 285Byteらしいです。雑に割る4すると71Byteでかなり短くてすごいですね)


### Lua (80B, murata)
```
h,w=io.read(2,3)for y=1,h do print("*"..(1==y%~-h and"*"or" "):rep(w-2).."*")end
```
- 標準入力のとり方は `h,w=io.read("n","n")` と書ける.`"n"` は数値を取ることを意味する。
- これだと`""`の分だけ冗長。引数に数値を入れるとその文字数分読んで値を返すことを使うと更に短縮できるテクがあるのでそれを使う。`io.read(2,3)` は `("50","\n50")` になる。数値は２桁固定なのでこの書き方が使える。
- Luaでは `if` を書くのは冗長になる。また三項演算子もない。ということでイディオムとして `a and b or c` を使うとそれなりに短く書ける。
- `1==y%(h-1)` と書くよりもビット演算を頑張って `1==y%~-h`と書くほうがコードが短くなる。
    - `y%h>1` だと、さらに3Byte短くなりそう (nonylene) 

### C (GCC) (86B, henkma)
```
h;c;i;main(w){for(scanf("%d%d",&h,&w);h;putchar(++i%w/2*c?32:i>w?c=--h-1,i=0,10:42));}
```
- 三項演算子を使って二重ループを一重化しています。
- 三項演算子の?と:は括弧のようなものなのでこの中は結合を気にせず記述できます。そのため、複雑な記述をしたい部分が?:の中になるように工夫しています。
- 最終的には私(henkma)が書いていますが、青チームの皆さん(特にdrafearさん)の協力でここまで縮めることができました。

### Whitespace (203B, drafear)
```
   	 
	
		   
	
		   	 	 	 
 
  
 
 	 
   	 
 
 				  	
  
   	     

 	 
   	
	    
 
		
 

 
 
 	 




   
 	  	 
	
     	 
   
				  	
  	
 
	 
 	
   
	   	
	    
 
			
 

 

 	  	
	
     	 	 
	
  
	
```

- https://vii5ard.github.io/whitespace/ にかけて読んでください
- 方針:

1. 入力を取る
2. `*` を w-2 回出力した後に改行する
3. `*` を出力した後に ` ` を w-2 回出力し, `*` を出力する. その後改行する. これを h-2 回繰り返す
4. `*` を w-2 回出力した後に改行する

### Kotlin (106B, murata)
```
fun main(){var a="aa".map{"*".padEnd(readLine()!!.toInt()-1)+"*"}
a[0].map{println(a[1].replace(' ',it))}}
```
- stringに対して`map`が可能で、しかも第一引数は `it` で使える.コレを使わない手はない。
- 変数の宣言には `var` か `val` が必須なこともあり、なるべくラムダ式で完結させたい言語である。
- padEndは何も指定しないと埋める文字に `' '`を使ってくれる。使わない手はない。
- 以上の特性のため、縦の`"*   *"` を作り、それを一文字ずつ取ってきて、横の`"*    *"` の `' '` を置換することになった。
- Kotlinを好きな人が多かったため大戦争に発展した.特に相手チームのゴルフテクを合わせるとさらに短くなるという可能性に満ちた言語であった
  - `"aa".map{}` を `List(2){}` にすると更に1byte減る
  - `var a=` を `var(h,w)=` にして `a[0]` を `h`, `a[1]` を `w` にすると更に3byte減る

### Alice (93B, @ten986)
```
/O ]  \67* ! [[![2-! ] /*\?1-&/.\?&  /"]"??[\<
@i? O /&?\ . /&-1?[\ * ~?/&-2?\./&-3?\* !?O /^
```
相手チームに書かれなさそうだったので適当に書いたものをちょっと最適化して出した

### GolfScript (29B, drafear)
```
~.'*'*n+:a"**"@((' '**n+@2-*a
```
- "**" "hoge" に対して * すると "\*hoge\*" になる

### Bash (busybox) (71B, drafear)
```bash
read h
read w
f(){
printf \\$[++i%w/2*c?40:i>w?c=h--%h,i=0,12:52];f
}
f
```
- `$(())` よりも `$[]`
- `$[]`の中身はCと似た構文の算術式をかけるのでCのコードで使っている条件式をベースに使った
- ただし`printf`で8進エスケープシーケンスとして出力するために10進化8進数を返している
- `printf`は`echo -e`よりも1B短い
- 再帰による無限ループは`for((;;)){ }`よりも得
- `h--%h` は 1,1,...,1,0 と遷移し, 最後にエラーを起こすためループを抜けられる


### なでしこ3 (114B, murata)
```
JS{{{for(let[h,w,c]=(""+require('fs').readFileSync(0)).split`
`;h;c=1)console.log(`*${"* "[c^!--h].repeat(w-2)}*`)
```
なでしこ3はjsで動くなでしこな為、 `JS{{{code}}}`　で jsを実行できます。
日本語は一文字書く毎に3byte程度使ってしまい明らかに損なので素直にjsを書きましょう。
phpが `<?php code; ?>`　を `<?php code;`と書けるのと同じ要領で、なでしこ3も `JS{{{code}}}` を `JS{{{code` と書いて最後の `}}}` を省略できます。
また、なでしこ3のjsは `"use strict"` が入っているため、代入には `let` や `var` が必要です。
従って、なでしこ3は +`JS{{{let`(8Byte) なだけの実質jsなのでした。
Emojicodeといい、なでしこといい、無駄に高機能なByte数のかかる言語はその意図されていたはずの言語系を使ってもらえなくて可哀想ですね...。


### Starry (83B, satos)
```
     +,       + *  `      + +   + * +  ',       + *           +            +  *`   +   +               + + .  *  + + . +   +   + *   +   + +   + `  + + .  +      + * + '  **  + + . +'
```

以下コードです(それぞれがどういう命令かは察してください)
hを長さhの列に変換しておくと短い。
```
	push(0) + geti + push(2) + sub + 
	mark(2) + 
	push(1) + dup + rot + sub + dup +
	jnz(2) +
	geti + push(2) + sub + push(6) + push(7) + mul + # w-2 42
	mark(0) + # w-2 42
	dup + putc + swap + rot + # w-2 ? 42 
	dup + rot + swap + # w-2 42 42 ?
	push(10) + dup + putc + mul + sub + # w-2 42 42|32  
	sub + # w-2 42 42|32
	rot + rot + dup + rot + # 42 w-2 42|32 w-2
	mark(1) + 
	swap + dup + putc + 
	swap + 
	push(1) + sub + dup + 
	jnz(1) + 
	# 42 w-2 42|32 0
	mul + add + swap + 
	# w-2 42 
	dup + putc + 
	# w-2 42 
	dup + jnz(0) + 
```

### Hexagony (83B, yamunaku)
```
?{?('&>{{42'3(>{$/("&+~...>.{{||/{$@1&_"'/{}/$/(<>\2{/;..'.}}"%'/..>;/=;-;.&~<=&'./

     ? { ? ( ' &
    > { { 4 2 ' 3
   ( > { $ / ( " &
  + ~ . . . > . { {
 | | / { $ @ 1 & _ "
' / { } / $ / ( < > \
 2 { / ; . . ' . } }
  " % ' / . . > ; /
   = ; - ; . & ~ <
    = & ' . / . .
     . . . . . .
```
頑張ってサイズ6の正六角形に詰めた
ループ開始時のメモリは以下のようになっている

```
   . _ .       . _ .
  /    h-1   '*'    \
 .       . _ .       .
  \     /    ' '    /
   . w .       . _ .
  /     h     /     \
 .       . _ .       .
```
 

### cmd.exe (191B, lake)

```cmd
set/pi=
set/ah=%i:~0,2%-1
set/aw=%i:~3,2%-2
for /l %%i in (1 1 %w%)do call set s=%%s%%-
for /l %%i in (0 1 %h%)do (set/ar=%%i%%%h%&call:o)exit
:o
if %r% equ 0(echo*%s:-=*%*)else echo*%s:-= %*
```

* (愚痴) ローカル (Windows) とサーバー (wine?) との間で動作に齟齬が起こりまくって本当に意味が分からなかった。
    * たとえば上のコードは手元 (Windows) では二箇所動作しない (は？) 。
        * `set /p` による入力は Windows では一行ごとに一つの変数に入る。
        * `exit` の前に改行がほしいらしい。
* なお上のコードは少なくともあと2バイトだけ短くできそう (`%h%` を `h` にしてもよいはず、おそらく。手元では動くがサーバーで動くかは...)
    * これは終了後に nagisa さんの提出を見て気付いたことです。
* 普通に考えると遅延評価のために `setlocal enabledelayedexpansion` という長いおまじないが必要に思える。
    * 実は `call` を使ったイディオムがあってこれで実質遅延評価ができる。
    * これは (全然機能不足だが) `eval` と似たしくみ。
    * コード上では `%%` とエスケープしておいたものが `set` の直前で `%` に置換され、その後に変数として評価されるため。
    * `set` のイディオムは `if` や `for` には使えないため、ここは別の関数に分けることで `%r%` の遅延評価を達成する。
    * というか `enabledelayedexpansion` の `!` による遅延評価、パラメータの置き換えが手元ではできるのにサーバー側ではできず (は？) 。

### Unreadable (1983B, satos)
```
貼りません(長い)
```

生成元のソースコードです
https://github.com/satos---jp/Esolang-Snippets/blob/b972a5bbfe594ab9130ee77ed85c7bfdc95dd7ce/unreadable.py
数を作る行為がやばいのでできる限り使いまわす、とかですかね。(まぁまだまだ縮みそうですが)

### Python 3 (68B, nonylene)
```python
a,b=map(int,open(0))
for i in f"*{' '*(a-2)}*":print(f"*{i*(b-2)}*")
```
- Python は range が長い・ for in に限られる・文字列のrepeat は楽に書ける のでこうした
- open で返ってくるのは Iterable なので map などできる
    - map を使うと関数入れるだけで済むので楽
- f-string 使わずに `"*"` を変数に入れても同じ長さになる

### PHP 7.0 (87B, nonylene)
```php
<?php
for([$a,$b]=file('php://stdin');$i<$a;)echo str_pad("
*",$b,"* "[++$i%$a>1])."*";
```

- str_repeat は長いので str_pad を使う
- `b-1` したくないので改行を str_pad の引数に入れる
- fgets 2回呼ぶよりは file のほうがお得
    - `cat` コマンド使ってもいいならもう1byte短くなる（自粛しました）。
    - by murata: `dd` で更に短くなりそう
- `<?=` 使えないかなと思ったけど長くなりそうだった。

### Make (101B, drafear)
```
SHELL=bash
a:
	@read h w<<<'$(STDIN:\n= )';f(){ printf \\$$[++i%w/2*c?40:i>w?c=h--%h,i=0,12:52];f;};f
```
- `SHELL=bash` をするとそのまま bash を書ける
- `echo "文字列"|コマンド` よりも `コマンド<<<"文字列"`
- `$(X:a=b)` で $X の "a" を "b" に置換したものになる
- 初めに宣言されたターゲットが実行されるので，名前はよくつかわれる`all:`である必要はない`
- 詳細は bash 参照

### Verilog (Icarus Verilog) (183B, polaris)
```
`define W $write("
module a;time w,h,t;initial begin t=$fscanf(1<<31,"%d%d",h,w);repeat(w)`W*");`W\n");repeat(h-2)begin `W*");repeat(w-2)`W ");`W*\n");end repeat(w)`W*");end endmodule
```
Verilogをしばいて難読化する（？）ことになる問題。整数値を保存したいときは`time`型を使うとお得。これはただの64bit整数値を表す。Verilogの`begin-end`ブロックはよく改行して書くけど実は他のトークンと見分けがつくなら空白文字すらいらないらしい。マクロを使うことで更に短くできた。少し困ったのは標準入力のファイルディスクリプタが`0x80000000`だったことと`$fscanf`の戻り値を必ず受けないといけないこと。また、`string`型を用いて更に短くできるような気もしたが検証する時間がなく終了。

### x86 Assembly (nasm) (217B, satos)
```
00000000  64 62 60 ba 05 5c 30 5c  30 5c 30 89 e1 bb 5c 30  |db`..\0\0\0...\0|
00000010  5c 30 5c 30 5c 30 b8 03  5c 30 5c 30 5c 30 cd 80  |\0\0\0..\0\0\0..|
00000020  31 c9 31 db 8a 04 24 2c  30 b1 5c 6e f6 e1 02 44  |1.1...$,0.\n...D|
00000030  24 01 2c 30 88 c3 8a 44  24 03 2c 30 f6 e1 02 44  |$.,0...D$.,0...D|
00000040  24 04 2c 30 fe c0 88 c1  f6 e3 8d 73 fe 0f be c1  |$.,0.......s....|
00000050  0f be d1 01 c2 c6 04 04  2a c6 04 14 20 48 4a 85  |........*... HJ.|
00000060  c0 75 f2 c6 04 24 2a c6  44 14 ff 5c 6e c6 44 54  |.u...$*.D..\n.DT|
00000070  ff 5c 6e c6 44 54 fe 2a  c6 04 14 2a 51 89 ca 8d  |.\n.DT.*...*Q...|
00000080  4c 24 04 bb 01 5c 30 5c  30 5c 30 b8 04 5c 30 5c  |L$...\0\0\0..\0\|
00000090  30 5c 30 cd 80 8b 14 24  8d 4c 14 04 bb 01 5c 30  |0\0....$.L....\0|
000000a0  5c 30 5c 30 b8 04 5c 30  5c 30 5c 30 cd 80 4e 85  |\0\0..\0\0\0..N.|
000000b0  f6 75 e8 8b 14 24 8d 4c  24 04 bb 01 5c 30 5c 30  |.u...$.L$...\0\0|
000000c0  5c 30 b8 04 5c 30 5c 30  5c 30 cd 80 b8 01 5c 30  |\0..\0\0\0....\0|
000000d0  5c 30 5c 30 cd 80 eb 94  60                       |\0\0....`|
000000d9
```
db\`\`でバイナリがそのまま埋め込めるのがえらいですね。
コード自体はそんなにgolfしてない。
あと手元で試したんですが、execveができるっぽいのでrubyとかのコードをそのまま埋め込むとえらい？


### Scheme (Guile) (158B, wass80)
```
(let* ((y (read))(x (read))(m make-string)(a append)(s (list (m (- x 1) #\*)))(k (string-join (a s (make-list (- y 2) (m (- x 2) #\ )) s)"*\n*")))(display k))
```
golfではない。

```
y := read
x := read
s := '*' * (x - 1)
k := (s ++ (' ' * (x-2)) ++ s).join("*\n*")
display k
```

どうみてもkが不要。

### gs2 (24B, drafear)
```
57 0e c9 07 2a ca 32 c8  0a 43 12 31 08 d2 d1 26 26 0d 32 d2 0a 09 32 d0
```

- documentが不十分なのでコードを読むとイケる
- 公式のコンパイラでgs2にコンパイルできるコード:

```
read-nums
extract-array
save-b
"*"
save-c
mul
save-a
new-line
rot
dec
dec
{
  push-c
  push-b
  dec
  dec
  space
  mul
  push-c
  new-line
}
mul
push-a
```


### Octave (78B, siotouto)
```
[h,w]=scanf("%d%d","C");s=repmat('*',h,w);s(2:h-1,2:w-1)=' ';disp(s)
```
- murataが書きました。ほとんど見たままだと思います。
- 数値のペアでとっていた入力をscanf("C")を使ってそれぞれ１文字アクセスできるようにしました。
- (by murata) charの行列(というか二次元配列)を簡単にいじれてしかもそのまま表示できるのは多分Octaveだけだと思います。もともと行列計算に向いている言語であり、今回の問題に最も輝いた言語なのではないでしょうか！!

### Snowman (110B, wass80)
```
{vG0aa'*48.'nS10nM`|1aA48nS-nA2nS*!vG0aa'*48.'nS10nM`|1aA48nS-nA1nS42'wRar|sp*'1nS32'wRaR"*
*"'sp'aC+#aRsP!#sP
```
- 書いただけ。変数と3レジスタしか使っていない
- `/[a-z][a-zA-Z]/` が命令． `/[*#=+!]/`は変数． 他の記号がmov
- <code>vG0aa'*48.'nS10nM`|1aA48nS-nA2nS</code>
  + 1行読み取り(`vG`) & 数値化(`aa'*48.'nS10nM`)
  + この繰り返しなんとかしたいですよね
- `42'wRar|sp*`
  + `***...*` をつくって出力(`sp`)
- `'1nS32'wRaR`
  + `␣␣␣...␣` をつくる
- `"*␊*"'sp'aC`
  + `*␊*␣␣␣...␣` 先頭に`*␊*` を追加する(`aC`)
- `+#aRsP`
  + 上の文字列を繰り返した文字列をつくって出力
- `!#sP`
  + 最初に作った`***...*`をつくって出力

### Node.js (106B, drafear)
```
for([h,w,c]=(""+require('fs').readFileSync(0)).split`
`;h;c=1)console.log(`*${"* "[c^!--h].repeat(w-2)}*`)
```

- `process.stdin.on('data', s=>...)` よりも `require('fs').readFileSync` の方が 1 byte 短い
- `c` は 0,1,...,1 と遷移し, `!--h` は 0,...,0,1 と遷移するので XOR を取るといい感じになる
- `"文字列"[index]` は便利
- 文字列が定数の場合, 関数('文字列') は 関数`文字列` と書ける
- (by nonylene's-idea) ` ""+require("fs").readFileSync(0)` は、 `0+require('fs').readFileSync(0)` と書ける(はじめに 0が来ても数値変わらなくて大丈夫なので)
- (by tyage's-idea) `},(x,r)=>...` で書き始めると `require` を `r` にできる

### Ruby 2.5.0 (54B, hanazuki)
```
h,w=$<.map &:to_i;puts _=?**w,[?*+?\s*(w-2)+?*]*h-=2,_
```
文字列リテラル`?*`はゴルフではおなじみ．代入演算子`-=`の優先順位は`*`よりも低いが，代入演算子の左側は，変数やそれに添え字がついたものまでしか広がらない特殊な性質を持ち，`[...]*(h-2)`と書くより1B節約できる

### Perl (57B, hanazuki)
```
$h=<>-2;print$a="*"x($w=<>),$/,("*",$"x($w-2),"*
")x$h,$a
```
初期状態で`$/`にはNL, `$"`にはスペースが入っている（それぞれ文字列リテラルと比べて-1B）．

### C# (Mono) (158B, murata)
```
using S=System.Console;class A{static int r=>int.Parse(S.ReadLine());static void Main(){for(int h=r,w=r,y=h;;)S.Write("*"+"*\n".PadLeft(w,"* "[y%h/y%y--]));}}
```
- `System.Console`を今回は２回書いたので `using S=System.Console` が一番短くなる。
  - 書く回数によっては `using static System.Console;` も選択肢に入る。`using S=` が `using static ` に伸びる代わりに、以降の `S.ReadLine` が `ReadLine` に変わり、宣言で5Byte損する代わりに以降2Byteずつ得になる。
- `static int r=>int.Parse(S.ReadLine());` は getter の省略記法。おかげで `int h=r()` ではなく `int h=r`と `()` を省略できる
- Repeat関数はcharではなく string をRepeatすることが多い。逆に Pad 系の関数は char をRepeatできることが多い。charを使えると、`(cond?" ":"*")` と書かずに `" *"[cond]` と書ける可能性があり、文字数が削減できて嬉しいのでPadは最高。
- 今回のコンテストでは、stdout に解答が出力されていれば 終了コードは問われなかったので、 0除算のエラーで異常終了させるようにした。
  - forのループ条件を書かなくてよくなり,コードが短くなる。(C#はint<->booleanを暗黙型変換しない(Cだと `for(;i--;)` と書けたところが `for(;i-->0;)`と書かないといけない)点もあって嬉しい)
  - `"* "[y%h/y%y--]` が異常終了処理と `'*'`と`' '` の選択処理を兼ねているというわけ
  - 余談として、コードゴルフの途中で `h%y--`的な処理を書いてしまい、 `h` が素数の時しか通らないコードが書けてしまって焦った
- 多分今回のC#はC#6で、C#7のローカル関数が使えるともう少し短くなるかもしれない。
- C#のプロ @tsutcho さんに勝ててよかったぜ。(と思ったけど最終的には異常終了を使わずに同Byte数になってたらしい...すごい...)

### C# (Mono)別解 (158B, tsutcho)
```
using C=System.Console;class Y{static int R=>C.Read()&15;static void Main(){for(int a=R*10+R,i=0,b=R*R+R;i<a;)C.Write("*"+"*\n".PadLeft(b,++i%a>1?' ':'*'));}}
```
- 短縮の方向性が違ったので別解として紹介。
  - 同バイトだったが提出が後だった。
- `static int R=>C.Read()&15;` は上述の通りプロパティのgetter。
  - こちらではReadLineではなくReadを使用。1文字の入力から文字コードをintとして取る。`&15`することで`'0'->0,'1'->1 ...`のように変換できる。数値の変換だけなら`-48`でも良いのだがこちらでは`'\n'->10`になる(超重要)。
- この`R`を用いて入力から数値を取る。今回は数値が2桁固定なので`a=R*10+R`とすると1つ目の入力値に一致する。
    - `R`はプロパティであり、メンバ変数のように見えるが内部的にはメソッドと同一である。そのため、呼び出すごとに値が変わるという状況を作ることができている。`a=R()*10+R()`みたいなイメージ。
- しかし、1文字ずつ入力する都合上、`a`を取得した後で`b`を取得するためには間の改行を飛ばす必要がある。そこで、前述の`R`の性質を利用する。
    - 改行文字が入力された時、`R`は10を返す。つまり、係数としての10の代わりに`R`を使えば、改行を飛ばすことが出来る。
        - しかも10→`R`に変更したことで1byte削減できる
    - つまり、例えば2つめの入力が34とすると`b=R*R+R`というのは`b=('\n'&15)*('3'&15)+('4'&15)`という状態になっている。
- `PadLeft`内の条件式については、nonyleneが作成してくれたものを使っている。
- とにかくこの手法は`'\n'==10`であることが重要で、これがなければ変数定義の部分が`int a=R*10+R,i=0*R,b=R*10+R`という形にならざるを得ず、3byte劣っていた。
    - しかも、こちらの書き方ではmurata式と統合できない
 - なお、この書き方では上で紹介されているローカル関数を使った短縮はできない。
     - ローカル関数にしてしまうと`R()`と書かなければならなくなり、`R`の呼び出し回数が多い現状では不利。
 - murataの方法とこちらの方法を統合すると最終的に下記の通り155Byteになる。
```
using C=System.Console;class Y{static int R=>C.Read()&15;static void Main(){for(int h=R*10+R,w=R*R+R,y=h;;)C.Write("*"+"*\n".PadLeft(w,"* "[y%h/y%y--]));}}
```
- 言うまでもないことだが、ここで使っているような「呼ぶたびに値が変わるプロパティ」というのは実際のコードで絶対に作ってはならない。
    - 今回のコードも、チーム内で「`R*10+R`って`R*11`？」という質問が出た。普通そう思うよね。
  
### Malbolge (???B, writer:murata)
```
解答コード無し
```
- 最終的に唯一埋まらなかった言語。むずい。
- https://www.trs.css.i.nagoya-u.ac.jp/Malbolge/index.html.ja を使えばまだまともな言語でコードを生成できるが、 "Hello"と出力するだけのコードですら 3kB に到達してしまう。 果たして今回の目的を満たすコードが 10kB(提出時の制約)で生成できるのだろうか...

### Vim (25B, lake)

```vim
Apl<Esc>ddD@"i*<Esc>dd@2<C-v>Gkehr<Space>ZZ
```
(バイナリになっている部分は読みやすいように変えました。)
* 入力をとるときにビジュアルモードや j を使いたくなるが (数字だけとろうとするとどうしてもそうなってしまう) これはキーストロークが増えて辛い。
    * なので数字の後ろに必要なコマンドを続けて行削除で取ることを考える。
    * `dd` を使うと改行コードが入る。これは空洞を作るときの一文字下移動に活用できる。
* 番号付きレジスタを使えばカットの順番を気にしなくてよい。
    * `"` レジスタだけを使おうとすると直前にカットする必要があって移動などが必要になる。

### SQLite3 (152B, @utgwkk)

```sql
with x as(select v,v k from i union select v,k-1 from x where k-1)select
printf('*%.'||(substr(v,3)-2)||'c*',case when k in(1,v)then'*'else' 'end)from x
```

文字の繰り返しは https://stackoverflow.com/questions/11568496/how-to-emulate-repeat-in-sqlite より。このsnippetめちゃくちゃ便利だけど他の言語の `printf()` 系関数では使えなさそう。
文字種が変わればトークン区切りの空白文字は不要。`()` があればとにかくつなげられる。https://www.sqlite.org/lang.html を読んでください。

そのほかに使った技法を列挙すると
- with句には`recursive`もカラム名宣言も不要
- 0はfalthyなのでwhere節に使える
- 文字列に対して(単項`+`以外の)四則演算を行うと、先頭から数字でなくなるまでの範囲の部分文字列を整数に変換してくれる
    - `'10\n20\n'-1`は`9`になる
- `k=1 or k=v`より`k in(1,v)`のほうが短い

### Java (182B, nonylene)
```java
interface A{static void main(String[]a){var s=new java.util.Scanner(System.in);for(int p=s.nextInt(),q=s.nextInt()+1,i=1;i<=p*q;)System.out.write(i++%q>0?i%q>2&i/q%~-p>0?32:42:10);}}
```
- まあ、頑張り
- はじめは repeat 使っていた
    - satos の gcc のコードを参考にして write を使ったら短くなった
- `System.out.write` は autoFlush しないので最後に改行を出力する必要がある
    - もしそうじゃなければ `<=` が `<` になって 1byte 減る
- 入っているバージョンが JDK12beta とかだったので var が使えた。これめっちゃ便利ですね。

### Rail (170B, satos)
```
$'m'
 -(!x!)(!s!)[]\       #
@---------------(x)0g<
  \---(!x!)s1(x)p(s)---@
$'main'
 -i25mmia(!h!)ii25mmia(!w!)[*](w){m}o[\n\*][ ](w)2s{m}p[*]p(h)2s{m}o[\n\]o[*](w){m}o#
```
m(s,n) がsをn回繰り返した文字列を返す。あとはappendとかで文字列を作って出すだけ。

### D (DMD) (118B, murata)
```
import std.stdio;void main(){int h,w,i;readf!"%d %d"(h,w);for(i=++w*h;i--;)write(~i%w/3&~(i/w)%h/2?' ':i%w?'*':'\n');}
```
- 実質C言語なので、C言語が短くなるとこっちも短くなる。
- C#やjavaと違ってboolとintが暗黙的に型変換されるところも偉い(偉くない)。
- 注意点として、comma expression (C言語だと`(1,2,3)`を前から評価して`3`になるやつ)はD言語では禁止されている。C言語がcomma expression でコードゴルフし始めたところからC言語に追随できなくなってしまった。

### Iwashi (1459B, drafear)
```
5ねんまえかのことでした
そして
4ねんまえかのことでした
はなはかれず
1ねんまえかのことでした
そして
すのこがきえるんだ
10ねんまえかのことでした
だれかがハサミで
すのこがきえるんだ
すのこがきえるんだ
9ねんまえかのことでした
はなはかれず
8ねんまえかのことでした
かぜはとまりつめたく
あしたのことはしっている
7ねんまえかのことでした
かぜはとまりつめたく
すのこがきえるんだ
すのこがきえるんだ
めがみえなくなってきた
6ねんまえかのことでした
はなはかれず
5ねんまえかのことでした
すのこがきえるんだ
aにあながあく
8ねんまえかのことでした
タイムラインをちょんぎった
0ねんまえかのことでした
はなはかれず
4ねんまえかのことでした
そらのうえからbがたつ
すのこがきえるんだ
dにあながあく
6ねんまえかのことでした
cにあながあく
タイムラインをちょんぎった
0ねんまえかのことでした
そらのうえからaがたつ
すのこがきえるんだ
そらのうえからdがたつ
4ねんまえかのことでした
そらのうえからdがたつ
3ねんまえかのことでした
とりはとばずねむる
そらのうえからdがたつ
7ねんまえかのことでした
cがつちからはえてくるんだ
bにあながあく
```

- 変数の番地は 0 から 2018 まで使える
- https://www.youtube.com/watch?v=d_T1StgldnM を聞きながら書くと短くなる
- コメント付き元コード:

```
# get h -> 6, 5
focus 6
getn
focus 5
add

# get w-1 -> 2
focus 2
getn
dec

# make consts
# 11: -3
focus 11
getc
dec
dec
# 10: -3
focus 10
add
# 9: 10
focus 9
mul
inc
# 8: 32
focus 8
mul
dec
dec
neg
# 7: 42
focus 7
add

# 9: 10
# 8: 32
# 7: 42
# 6: h
# 5: i
# 4: *
# 3: -
# 2: w
# 1: j
# 0: *

# main
focus 6
dec
y:
  # print \n
  focus 9
  putc
  # w -> 1
  focus 1
  add
  focus 5
  jz exit
  dec
  x:
    focus 7
    space:
    putc
    # step
    focus 1
    jz y
    dec
    # if y = 0 \/ y = h \/ x = 0 => goto x
    jz x
    focus 5
    jz x
    focus 4
    sub
    jz x
    # else => goto space
    focus 8
    jgz space
exit:
```

### ><> (70B, yamunaku)
```
ia*i+86*b*:}-i13pia*i+{-:vo"*"<
o{1-:?!;:3g48*+47*0p}o:1->1-:?^~"*":oa
```
befungeのコードをfishの仕様に合わせた。
入力がbefungeより改悪されてて怒った。
スタックの底から要素を持ってこれるのが少しうれしい。
befungeとは違って無を取得すると空白(32)ではなく0が入るので、そこの調整に手間取った。
10を配置して、取得したものと32を足し合わせることで、空白(32)と'*'(42)を表現した。

### Rust (177B, lake)
```
use std::io::*;fn main(){let i=&mut[0;9];stdin().read(i);let(h,w)=(i[0]%48*10+i[1]-49,i[3]%48*10+i[4]-50);for i in 0..=h{println!("*{}*",if i%h>0{" "}else{"*"}.repeat(w as _))}}
```
- Rust は安全性をウリにしていて、暗黙の型変換をしてくれなかったり、一々 unwrap() したりする必要があり、文字数の関係で高級な関数達がほとんど使えない。
    - 例: 入力を文字列に取ろうとすると `let mut i = String::new(); stdin().read_to_string(&mut i);`
    - 例: 改行で区切って数字に変換しようとすると `if let [h,w] = i.split('\n').map(|x| x.parse().unwrap()).collect::<Vec<_>>() {}`
    - 例: 改行で区切って数字に変換しようとすると `let mut s = i.split('\n'); let (h, w) = (s.next().unwrap().parse().unwrap(), s.next().unwrap().parse().unwrap())`
- 普通のプログラムはきれいにかける言語ではあるけれどゴルフ向きではなさすぎる...。
- 普通は `let mut i = [0; 9]; stdin().read(&mut i)` となるが、 Rust は右辺値への &amp;mut 参照が匿名ローカル変数を作成してそれへの参照、となるので、少し短くできる。
- `read()` の `Result` 無視しても警告なので問題ない。
- ロジックの部分では、 `h` 回ループして最初の行と最後の行のときとそうでないときとでうまくやる自然な解答。
    - あらかじめ `h` から 1 を引いておいて、 0 ～ h-1 までループしつつ、ループカウンタを (h-1) でわったあまりが 0 かどうかで最初と最後を判別している。
    - 三項演算子などもないし、文字列は char の配列だったりしないし、 int -> bool の暗黙変換もないし、どうにもならない...。
    - あげく u8 -> usize などの暗黙変換もしてくれないので、文字列→数字変換で大きい数字を使えなかったり (u8 から脱する方法がないので 0 ～ 255 でしか計算できない) 、 `as _` が必要だったり。
- by murata: `(i[0]-48)*10` は `i[0]%48*10` と書ける。演算子の優先順位最高〜

### Haskell (76B, henkma)
```
main=interact$foldl(\s x->init$do c<-s;'*':(c<$[3..read x])++"*\n")" ".words
```
- 基本的な考え方は「\c x->'*':replicate x c++"*" という関数を使い倒す」です。
- foldl と リストモナドを使ってこれを効率的に実現しています。
- 「リストの各要素に関数を適用して連結」という処理をしていますが、これには「concat[f x|x<-l]」「[f x|x<-l]>>=id」「l>>=f」「do x<-l;f x」等々、様々な記述方法があります。今回の状況ではdo を使った表現が最善のようでした。
- Haskell はゴルフしても可読性がわりと高めなのがいいですね。

### APL (88B, polaris & drafear)
```
b←⍕⎕ARG[6]
w←⍎b[5 6]
wρ"*"
((⍎b[2 3])-2)wρ"*",((w-2)ρ" "),"*"
wρ"*"
)OFF
```
[本質情報](https://lists.gnu.org/archive/html/bug-apl/2016-03/pdfnhfxtQXCtP.pdf) と [APLで使う記号一覧](https://en.wikipedia.org/wiki/APL_syntax_and_symbols) がなかったら誰もかけなかったのかもしれない実用言語。ほとんど愚直解。今回は`⎕ARG[6]`でスクリプトへの引数を文字列で取ることができ、文字列へ変換(`⍕`)した後Eval(`⍎`)することで入力を得ている。このコンテストでの処理系はGNU APLで、これがどうも出力が80bytesを超えた際に自動的に改行してしまうらしい。問題によっては解なしになってしまうかも。

### Crystal (64B, murata)
```
h,w=`dd`.split.map &.to_i;puts q="*"*w,"*#{" "*(w-2)}*
"*(h-2),q
```
- Rubyの厳格版。コンパイルできて高速らしい。
- 入力を取る時は普通に`gets`で取ると`nil`チェックが必要で冗長になるので `STDIN.each_line.map(&.to_i).to_a` を使うべき。
- 更にこれでも冗長で、`dd`を実行した結果(文字列)を使うと最終的に `dd.split.map &.to_i` と書ける
- 代入式が使えるので、最初の引数に入れた`q="*"*w` で,変数 `q` が後の引数で使える。

### 05AB1E (24B, @dnek_)
```
<'*DIÍú«Dð'*:=rG=}U?
```
- `<` (入力-1)をpush
  - stackから項を取れないときは入力から補われる

- `'*D` `'*'`をpushして複製

- `IÍú«` (入力-2)でPadLeft, concat e.g. `"*   *"`

- `Dð'*:` 複製して`' '`を`'*'`に置換

- `=r` popせずに出力改行、stackをreverse

- `G=}` [1,n)で`=`をloop

- `U?` グローバル変数Xに代入、改行なし出力
  - popしたかっただけなんだけどパッと見つからなかったので代用

- とにかく[公式Wiki](https://github.com/Adriandmen/05AB1E/wiki)を読み込む。

### Shakespeare (1148B, yamunaku)
<details><summary>コードを見る</summary>

```
.
Ajax,.
Ford,.
John,.
Julia,.
Page,.
Puck,.
Act I:.
Scene I:.
[Enter Julia and Ford]
Ford:
Listen to thy heart.
Julia:
Listen to thy heart.
[Exeunt]
[Enter John and Ajax]
John:
You is sum of old joy and old big red joy.
Ajax:
You is old big red fat bad joy.
[Exit John]
[Enter Page]
Ajax:
You is sum of I and John.
[Exeunt]
Scene II:.
[Enter Page and Puck]
Page:
You is sum of you and joy.
Puck:
Speak thy mind.Am I worse than Ford?
Page:
If so, let us return to Scene II.You is big joy.
[Exit Page]
[Enter Ajax]
Puck:
Speak thy mind.
[Exeunt]
Scene III:.
[Enter Page and Puck]
Puck:
Speak thy mind.
[Exit Page]
Scene IV:.
[Enter John]
John:
You is sum of you and joy.
Puck:
Speak thy mind.Am I worse than Ford?
John:
If so, let us return to Scene IV.You is big joy.
[Exeunt]
[Enter Page and Ajax]
Ajax:
Speak thy mind.
Page:
Speak thy mind.
[Exit Ajax]
[Enter Julia]
Page:
You is sum of you and lie.is you nicer than big joy?
Julia:
If so, let us return to Scene III.
[Exit Julia]
[Enter Puck]
Page:
You is zero.
Scene V:.
Page:
You is sum of you and joy.
Puck:
Speak thy mind.Am I worse than Ford?
Page:
If so, let us return to Scene V.
[Exeunt]
```

</details>

公式ドキュメントを読んで何となく理解する。
ステージがあって、そこに登場人物を模したメモリが2つ登場できる。
相手に話しかけることで相手の中身を変えたり出力させたりすることができる。

You is (名詞). が代入文。
名詞は整数を表し、相手の中身をその整数に変える。
良い名詞と悪い名詞があって、良い名詞は+1,悪い名詞は-1を表す。
名詞に異なる形容詞をつけるたびに、表す数が2倍される。

Speak thy mind.が出力。
相手の中身をascii文字として出力させる。

疑問文で条件分岐ができる。
良い形容詞で>, 悪い形容詞で<, as ~ asで==を指す。
Act番号やScene番号がラベルになっていて、
If so, let us return to (ラベル)
で条件を満たすときにラベルに飛ぶことができる。

スタックの機能もあるらしいけど使わなかった。

https://github.com/drsam94/Spl/tree/master/include
ここに使える単語が載っているので短いのを選んでいく。

### Unlambda (8804B, satos)
```
貼りません(長い)
```

https://github.com/satos---jp/lambda_implementation
これを基にしました。
生成に使ったのは
https://github.com/satos---jp/lambda_implementation/blob/master/unlambda_ruby/kmc.rb
です。
本質は以下のλ式。
```
  (ri.
    (x. y.
      y .A .C
      ($dec ($dec x))
        (z. z .A I (($dec ($dec y)) .B z) .A .C I) I
      y .A I
    )
    ($bin2churchdo (ri *0)) ($bin2churchdo (ri *0))
  ) $read_int I I
```


### OCaml (122B, @utgwkk)

```ocaml
let b,a=read_int()-2,read_int()let _=for i=1 to a do
Printf.printf"*%s*
"(String.make b(if i=1||i=a then '*'else ' '))done
```

素直に書いて短くした。
分割代入は右から評価されるし、括弧は不要。

### メモ書き
- by murata: http://esolang-0.wass80.xyz/contests/komabasai2018-day1/submissions/5ca4bdc9c9ca4c4639eb0a23 みたいな、間違ってシェルピンスキーのギャスケットを書いてしまったりするのが好きです。