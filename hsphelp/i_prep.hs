;
;	HSP help manager用 HELPソースファイル
;	(先頭が「;」の行はコメントとして処理されます)
;

%type
内蔵命令
%ver
3.5
%note
ver3.5標準命令
%date
2017/09/13
%author
onitama
%url
http://hsp.tv/
%port
Win
Cli


%index
#define
新規マクロを登録する
%group
プリプロセッサ命令
%prm
マクロ名 マクロ定義
%inst
マクロ名で指定されたキーワードを指定された定義に置き換えられるようにプリプロセッサに登録をします。
#defineマクロは、 あくまで個人がスクリプトを書きやすくカスタマイズしたい場合に使うもので、初心者向きではありません。ここで説明した機能も、頻繁に利用するものではありませんので、必要な場合にのみ参照してください。
#defineマクロは、基本的に置き換え文字列を登録します。
^p
例 :
	#define hyouji mes
	hyouji "AAAAA..."
		↓(展開後)
	mes "AAAAA..."
^p
#define命令の直後に「global」を入れることで、 すべてのモジュールで永続的に利用することのできるマクロを作成することができます。
^p
例 :
	#module
	#define global test 0x1234
	#global
	a=test   ; aに0x1234が代入される
^p
通常は、モジュール内で#defineを定義した場合には、それ以外のモジュールおよびグローバルなエリアでは、同じ名前は認識されません。
global指定を入れることで、それ以降のすべての場所で定義した名前をマクロで置き換えることができるようになります。
^
単純な置き換えマクロの他に、引数付きの展開が可能です。
引数は、マクロ名の後にカッコで囲んだ%1,%2,%3…の引数名で指定を行ないま
す。
引数は必ず「%数値」で指定する必要があり、 数値は１から順番に記述してください。CやC++のプリプロセッサのようにシンボル名では指定できないので注意してください。
^p
例 :
	#define hyouji(%1) mes "prm="+%1
	hyouji "AAAAA..."
		↓(展開後)
	mes "prm="+"AAAAA..."
^p
また、引数に初期(デフォルト)値を設定することが可能です。
^p
例 :
	#define hyouji(%1="PRM=",%2=123) mes %1+%2
	hyouji "AAA",a
	hyouji "BBB"
	hyouji ,b
		↓(展開後)
	mes "AAA"+a
	mes "BBB"+123
	mes "PRM="+b
^p
初期(デフォルト)値は、マクロを使用した時に省略された場合に自動的に補完される値です。初期値を省略された場合は、補完されません。
マクロ引数の指定では#defineで指定する側では、カッコで囲んでいますが、実際に使用する時にはカッコなしで指定してください。
^p
	#define hyouji(%1) mes "prm="+%1
	hyouji("AAAAA...")
^p
のような記述はエラーになるので注意してください。
ただし、 ctypeオプションを使用することで以下のようなカッコ付き記述が可能になります。
^p
	#define ctype kansu(%1) %1*5+1
	a=kansu(5)
^p
このオプションは、計算式など命令部分以外にマクロを使用したい時に有効です。一見、C言語などの関数のように振舞いますが、 実際にはマクロで置き換えているだけなので、応用範囲は狭いので注意してください。
この記述方法は、 本来のHSP文法とは異なるため自分のスタイルで記述したいというカスタマイズ用途以外での利用は推奨していません。
^
マクロの展開時に特殊な動作を行なうキーワードを設定することが可能です。
この特殊キーワードは、主にことなるマクロ間でパラメータを共有したり、入れ子構造をスタックによって実現するためのものです。
^p
	#define start(%1) %tstart %s1 mes "START"
	#define owari %tstart mes %o
^p
ここで指定されている「%s1」や「%o」などが特殊展開マクロです。
これを使ったサンプルは、以下のように展開されます。
^p
	start "OK" → mes "START"
	owari → mes "OK"
^p
このように、異なるマクロ間でデータを共有させることが可能になります。
特殊展開マクロは、以下の種類と機能があります。
^p
   マクロ : 機能
 ----------------------------------------------------------------
     %t   : タグ名を設定する
     %n   : ユニークなラベル名を生成する
     %i   : ユニークなラベル名を生成してスタックに積む
     %o   : スタックに積まれた文字列を取り出す
     %p   : スタックに積まれた文字列を取り出す(スタック維持)
     %s   : 引数パラメーターをスタックに積む
     %c   : 改行を行なう
^p
特殊展開マクロは、「%」に続けて英文字1文字+パラメータで表現します。
以降のキーワードと識別するために、特殊展開マクロの後には半角スペースを入れて下さい。「%tabc aaa」 のようスペースを含む部分までが特殊展開マクロと判断されます。
特殊展開マクロでは、一般的なスタック(First In Last Out)を持っています。
このスタックは、同じタグ名を持つマクロで共有させることができます。
タグ名は、「%tタグ名」のように「%t」に続けて半角英文字16字以内で指定します。先の例では「%tstart」と指定された「start」がタグ名にあたります。
「%s」は、引数パラメーターをスタックに積むための特殊展開マクロです。
「%s1」と指定すると、「%1」のパラメータをスタックに１段積みます。
スタックに積まれた文字列を取り出す場合は、「%o」を使用します。
「%o」は、スタックに積まれた文字列を取り出して展開します。スタックなので、最後に積まれたものが最初に取り出されます。
「%o0」と指定すると、 スタックを取り出しますが文字列の展開は行ないません(スタック取り出しのみ)。
スタックを戻さずに内容だけを取り出すのが 「%p」です。「%p0」は、次に取り出されるスタックの内容を展開します。「%p1」は、 もう一段深いスタックを取り出します。以降、「%p0」〜「%p9」までを指定することが可能です。
ラベル生成の例を以下に示します。
^p
	#define start %tstart *%i
	#define owari %tstart await 20:stick a:if a=0  :  goto
*%o
^p
これを使ったサンプルは、以下のように展開されます。
^p
	start → *_start_0000
	owari → await 20:stick a:if a=0 : goto *_start_0000
^p
「%i」は、他と重ならないようなユニークなラベル名を生成してスタックに１段積みます。「%i0」と指定するとラベル名をスタックに１段積みますが、展開は行ないません。 
また、「%n」は、ユニークなラベル名を生成して展開するだけで、スタックには積みません。
上の例では、ラベル名生成によってラベルを新しく作成して、 ループ構造を実現しています。 この方法を使えば、入れ子になってもラベル名が重なることのないループ構造を構築することができます。
また、1つのソーススクリプトファイル内ですべてのスタックが取り出されていなかったマクロ(タグ名)は、コンパイル時にエラーが報告されます。
かならず、すべてのスタックが取り出されて終わるようなマクロ命令の構成にしておいてください。
^
HSP ver2.6で追加された標準定義マクロの while〜wend、 do〜until、 for〜nextは特殊展開マクロによって作られています。
^
特殊な場面において、「%c」によって改行を挟んで展開することが可能です。
「%c」の部分で行が分割されて展開されます。主に複数のプリプロセス文に展開されるようなマクロを定義する用途などに使用することができます。
ただし、現状ですべてのプリプロセッサがマクロ展開に対応しているわけではありません。多用しすぎると、かえって見難くなることもありますので、よくご理解の上お使いください。
^p
例 :
	#define def(%1,%2) #deffunc %1@ %c mes@hsp %2@
	def test,a
	return
	def test2,a
	return
^p
%href
#const
#ifdef
#ifndef
%port+
Let


%index
#func
外部DLL呼び出し命令登録
%group
プリプロセッサ命令
%prm
新規名称 "関数名" タイプ名1,…

%inst
外部DLLを呼び出すための新しい命令を登録します。
先に#uselib命令により外部DLL名を指定しておく必要があります。
新規名称、関数名、タイプをスペースで区切って書きます。
新規名称の直前に「global」を入れることで、 すべてのモジュールで永続的に利用することのできる命令を作成することができます。
^
関数名は、"関数名"のようにダブルクォートで囲むことで、 DLLの完全なエクスポート名を記述することができます。
ダブルクォートで囲んでいない場合は、「_関数名@16」というVC++のエクスポート規約に基づいた名前に変換されます。
^
タイプ名には、引数の詳細を記述します。
#deffunc命令と同様に、引数の型を「,」で区切って指定してください。
引数の数や、型の順番に制限はありません。
引数の型として使用できる文字列は以下の通りです。
^p
     型     :  内  容
 ------------------------------------------------------------------
    int     :  整数値(32bit)
    var     :  変数のデータポインタ(32bit)
    str     :  文字列ポインタ(32bit)
    wstr    :  unicode文字列ポインタ(32bit)
    sptr    :  ポインタ整数値または文字列のポインタ(32bit)
    wptr    :  ポインタ整数値またはunicode文字列のポインタ(32bit)
    double  :  実数値(64bit)
    float   :  実数値(32bit)
    pval    :  PVal構造体のポインタ(32bit)
    comobj  :  COMOBJ型変数のデータポインタ(32bit)
(*) bmscr   :  BMSCR構造体のポインタ(32bit)
(*) prefstr :  システム変数refstrのポインタ(32bit)
(*) pexinfo :  EXINFO構造体のポインタ(32bit)
(*) nullptr :  ヌルポインタ(32bit)
^p
(*)がついている項目は、 引数として指定する必要なく自動的に渡されるパラメーターを示しています。
以下は、４つの引数を指定して実行する例です。
^p
例 :
	#uselib "test.dll"
	#func test "_func@16" var,int,int,int
	test a,1,2,3    ; test.dllのfunc(&a,1,2,3)が呼び出される
^p
タイプに数値を指定した場合は、ver2.5以降のDLLタイプ指定と互換性のある引数が自動的に設定されます。ただし、いくつか互換性のない指定値があります。その場合は、コンパイル時にエラーとして報告されます。
^
ver2.5とは以下の点で互換性の注意が必要です。
^p
・BMSCR構造体は、flagからcolorまでのフィールドのみ参照できます。
・PVal構造体は、ver2.5のPVAL2構造体と互換があります。
・PVal構造体のflagフィールド(型タイプ値)やlenフィールド(配列情報)をDLL側で書き換えることはできません。
・PVal構造体から文字列型の配列変数にアクセスすることはできません。
^p
これ以外の点においては、HSP ver2.5と同等の情報が受け渡されます。
^
関数名の前に「onexit」を入れることにより、終了呼び出し関数として登録することができます。
^p
例 :
	#func test onexit "_func@16" str,int,int
^p
上の例では、アプリケーション終了時に自動的に"_func@16"が呼び出されます。


%href
#uselib
#cfunc
%port+
Let
%portinfo
HSPLet時は、関数と同名のメソッドが呼ばれることになります。(詳細は、HSPLetマニュアルを参照してください。)


%index
#cfunc
外部DLL呼び出し関数登録
%group
プリプロセッサ命令
%prm
新規名称 "関数名" タイプ名1,…

%inst
外部DLLを呼び出すための新しい関数を登録します。
先に#uselib命令により外部DLL名を指定しておく必要があります。
新規名称、関数名、タイプをスペースで区切って書きます。
新規名称の直前に「global」を入れることで、 すべてのモジュールで永続的に利用することのできる命令を作成することができます。
^
関数名は、"関数名"のようにダブルクォートで囲むことで、 DLLの完全なエクスポート名を記述することができます。
ダブルクォートで囲んでいない場合は、「_関数名@16」というVC++のエクスポート規約に基づいた名前に変換されます。
^
タイプ名には、引数の詳細を記述します。
引数パラメーターは、#func命令と同じものを使用することができます。
詳しくは、#funcのリファレンスを参照してください。
#cfunc命令によって登録された新規名称は、関数として式の中に記述することが可能です。
^p
例 :
	#uselib "test.dll"
	#cfunc test "_func@16" var,int,int,int
	res=test(a,1,2,3)  ; test.dllのfunc(&a,1,2,3)が呼び出される
^p
登録された関数の戻り値として外部呼出しの結果取得された整数値(32bit int)をそのまま返します。
HSP2.5互換の呼び出しでは、システム変数statに返される値を関数の戻り値とします。


%href
#uselib
#func
%port+
Let
%portinfo
HSPLet時は、関数と同名のメソッドが呼ばれることになります。(詳細は、HSPLetマニュアルを参照してください。)






%index
#include
別ファイルを結合
%group
プリプロセッサ命令
%prm
"filename"
"filename" : 結合するファイル名

%inst
インクルードするファイルを指定します。
ここで指定されたファイルは、もとのファイルに結合してコンパイルされます。

%href
#addition
%port+
Let



%index
#addition
別ファイルを結合2
%group
プリプロセッサ命令
%prm
"filename"
"filename" : 結合するファイル名

%inst
インクルードするファイルを指定します。
ここで指定されたファイルは、もとのファイルに結合してコンパイルされます。
#include命令と同じ動作ですが、#additionはファイルが存在しない場合でも、エラーとして停止せずに続行されます。
追加の定義ファイルなどを結合する場合に使用します。

%href
#include
%port+
Let



%index
#uselib
外部DLLの指定
%group
プリプロセッサ命令
%prm
"filename"
"filename" : 外部DLLファイル名

%inst
HSPから呼び出す外部DLLのファイル名を指定します。
DLLのファイル名は、拡張子も含めて完全に書く必要があります。
ファイル名を省略した場合は、 実行時にスクリプトからDLL名を指定してリンクを行なうことになります。

%href
#func
%sample
	#uselib "user32.dll"
	#func MessageBoxA "MessageBoxA" int,sptr,sptr,int
	MessageBoxA hwnd,"test message","title",0
%port+
Let
%portinfo
HSPLet時は、指定された DLL と同名のクラスが読み込まれます。
読み込まれるクラス名は、末尾から .dll または .hpi を除いたものになります。
たとえば、winmm.dll を使用すると、 winmm クラスが読み込まれます。 
独自の拡張ライブラリクラスを作成したときは、JAR ファイルを lib フォルダの中においてください。
コンパイラが自動的に認識してコンパイル時にチェックがつけられるようになります。



%index
#global
モジュールの終了
%group
プリプロセッサ命令
%prm
%inst
モジュール区間を終了し、以降を通常のプログラム領域に戻します。
モジュールについての詳細は、#module命令を参照してください。
%href
#module
#deffunc
%port+
Let




%index
#module
モジュールの開始
%group
プリプロセッサ命令
%prm
モジュール名 変数名1,…
モジュール名 : 新規モジュール名
変数名       : 登録するモジュール変数名

%inst
#module以降の区間をモジュールとして別な空間に割り当てます。
モジュール内の変数やラベルは、モジュール外のものからは独立したものになります。
^
"モジュール名"は、複数のモジュールを名前で区分けする時につけることのできる名前で、モジュール名が同じもの同士は、変数名やラベル名を共有します。
モジュール名が違うものの間では、変数名やラベル名はまったく違うものとして扱われます。
^
"モジュール名"を省略した場合は、「m数値」という名前が自動的に割り当てられます。
^
モジュールは、必ず「#module」で開始を指示し、「#global」で終了しなければなりません。このようにモジュールの区間を指定することにより、その中を他から独立した空間にすることができます。
モジュール名は、18文字以内の長さで他の変数名などのキーワードと重複することはできません。
また、スペースや記号を含まない文字列を指定するようにしてください。 (モジュール名で使用できる文字種は、a〜zまでのアルファベット、0〜9までの数字、「_」記号となります。変数として使用できる文字列と同等です。)
^
モジュール変数名は、モジュールに関連付けられたローカルな変数を登録しておくものです。登録されたモジュール変数名は、#modfunc、または#modcfuncで定義された処理ルーチン内で使用することができるようになります。
^
モジュール変数についての詳細は、プログラミングマニュアル(hspprog.htm)を参照してください。

%href
#global
#deffunc
#modfunc
#modcfunc
#modinit
newmod
delmod
%port+
Let




%index
#deffunc
新規命令を登録する
%group
プリプロセッサ命令
%prm
p1 p2 p3,…
p1      : 割り当てられる命令の名前
p2 p3〜 : パラメータータイプ名・エイリアス名

%inst
ユーザーによる新規命令を登録します。
p1に新規命令の名前を、p2以降に呼び出しパラメータタイプを指定します。
#deffunc命令で定義した名前をスクリプト内で命令として使用することが可能になります。
^
新規命令は、#deffuncで指定された行以降が実行される内容になります。
実行は gosub命令と同じくサブルーチンジャンプとして行なわれ、return命令でもとの実行位置に戻ります。
^p
例 :
	#deffunc test int a
	mes "パラメーター="+a
	return
^p
追加された新規命令ではパラメータを受け取ることができるようになります。
それぞれのパラメータには、パラメータタイプとエイリアス名の指定が可能です。指定するパラメータタイプには以下のものがあります。
^p
   int     :  整数値
   var     :  変数(配列なし)
   array   :  変数(配列あり)
   str     :  文字列
   double  :  実数値
   label   :  ラベル
   local   :  ローカル変数
^p
エイリアス名は、渡されたパラメーターの内容を示すもので、変数とほとんど同じ感覚で使用することができます。
varとarrayの使い分けには注意が必要なほか、 ローカル変数を示すlocalタイプは特殊な用途となります。
詳しくは、プログラミングマニュアル(hspprog.htm)のモジュール項目を参照してください。

特殊な用途として、パラメータータイプの替わりに「onexit」を記述することで、クリーンアップ命令として登録することができます。クリーンアップ命令は、HSPスクリプト実行の終了時に自動的に呼び出されます。 
^p
例:
	#deffunc 名前 onexit
^p
モジュールによって機能を拡張した場合などにその後始末、システムやメモリの解放などを行なうために利用することができます。 
^
新規命令の名称は、通常すべてのモジュール空間、グローバル空間で共有されます。
ただし、local指定の後に名称を指定した場合は、モジュール固有のものとして扱われます。
^p
例 :
	#module user
	#deffunc local test int a
	mes "パラメーター="+a
	return
	#global
	test@user 5
^p
これは、モジュール内でのみ使用される命令を定義する場合などに使用することができます。
local指定により登録された名称は、必ず「名称@モジュール名」の形式で呼び出す必要があります。


%href
#global
#module
#modfunc
#modcfunc
#modinit
#modterm
mref
%port+
Let
%portinfo
HSPLet時、引数の型は str/int/double/var/array のみサポートされています。
local などは指定できません。 


%index
#defcfunc
新規関数を登録する
%group
プリプロセッサ命令
%prm
p1 p2 p3,…
p1      : 登録する関数の名前
p2 p3〜 : パラメータータイプ名・エイリアス名

%inst
ユーザーによる新規関数を登録します。
p1に新規関数の名前を、p2以降に呼び出しパラメータタイプを指定します。
#defcfunc命令で定義した名前をスクリプト内で関数として使用することが可能になります。
^
新規関数は、 #defcfuncで指定された行以降が実行される内容になります。実行はgosub命令と同じくサブルーチンジャンプとして行なわれ、 return命令でもとの実行位置に戻ります。
その際にreturn命令に戻り値のパラメーターを指定する必要があります。
^p
例 :
	#defcfunc half int a
	return a/2
^p
追加された新規関数ではパラメータを受け取ることができるようになります。
それぞれのパラメータには、パラメータタイプとエイリアス名の指定が可能です。指定するパラメータタイプには以下のものがあります。
^p
   int     :  整数値
   var     :  変数(配列なし)
   array   :  変数(配列あり)
   str     :  文字列
   double  :  実数値
   local   :  ローカル変数
^p
エイリアス名は、渡されたパラメーターの内容を示すもので、変数とほとんど同じ感覚で使用することができます。
varとarrayの使い分けには注意が必要なほか、 ローカル変数を示すlocalタイプは特殊な用途となります。
詳しくは、プログラミングマニュアル(hspprog.htm)のモジュール項目を参照してください。
^
新規関数の名称は、通常すべてのモジュール空間、グローバル空間で共有されます。
ただし、local指定の後に名称を指定した場合は、モジュール固有のものとして扱われます。
^p
例 :
	#module user
	#defcfunc local test int a
	return a+5
	#global
	mes test@user(5)
^p
これは、モジュール内でのみ使用される関数を定義する場合などに使用することができます。
local指定により登録された名称は、必ず「名称@モジュール名」の形式で呼び出す必要があります。

%href
return
#deffunc
%port+
Let
%portinfo
HSPLet時、引数の型は str/int/double/var/array のみサポートされています。
local などは指定できません。 



%index
#pack
PACKFILE追加ファイル指定
%group
プリプロセッサ命令
%prm
"filename"
"filename" : PACKFILEに追加されるファイル
%inst
実行ファイル自動作成(ctrl+F9)で、 packfileに追加されるファイルを指定します。指定されたファイルは、実行ファイル作成時にリソースとして一緒にパックされます。#packは、通常の形式でパックします。 暗号化してパックしたい場合は#epackをお使い下さい。
重複したファイルを追加しようとした場合には、無視されます。
「start.ax」は、実行ファイル自動作成の際に自動的に追加されるため特に追加ファイルとして指定する必要はありません。
^p
例 :
	#pack "a.txt"
^p
上の例では、「a.txt」というファイルを実行ファイルと一緒にパックします。
今まで通りに、「packfile編集」からパックされるファイルを選択して実行ファイルを作成することも可能です。
「実行ファイル自動作成」を行なうと、packfileが自動的に作成されるため、それまで保存されていたpackfileの情報は上書きされるので注意して下さい。

%href
#epack
#packopt


%index
#epack
PACKFILE暗号化ファイル指定
%group
プリプロセッサ命令
%prm
"filename"
"filename" : PACKFILEに追加されるファイル
%inst
実行ファイル自動作成(ctrl+F9)で、 packfileに追加されるファイルを指定します。指定されたファイルは、実行ファイル作成時にリソースとして一緒にパックされます。#epackは、指定ファイルを暗号化してパックします。
暗号化を行なう必要がない場合は#packをお使い下さい。
重複したファイルを追加しようとした場合には、無視されます。
「start.ax」は、実行ファイル自動作成の際に自動的に追加されるため特に追加ファイルとして指定する必要はありません。
^p
例 :
	#epack "a.bmp"
^p
上の例では、「a.bmp」 というファイルを暗号化して実行ファイルと一緒にパックします。
今まで通りに、「packfile編集」からパックされるファイルを選択して実行ファイルを作成することも可能です。
「実行ファイル自動作成」を行なうと、packfileが自動的に作成されるため、それまで保存されていたpackfileの情報は上書きされるので注意して下さい。

%href
#pack
#packopt


%index
#packopt
自動作成オプション指定
%group
プリプロセッサ命令
%prm
p1 p2
p1 : キーワード
p2 : 設定内容
%inst
実行ファイル自動作成の動作を指定します。
キーワード名、の後スペース又は TAB を入れてパラメーター(文字列の場合は「"strings"」のように指定)を記述して下さい。
#packoptで指定できるキーワードは以下の通りです。
^p
  キーワード |      内      容        | 初期値
 ------------------------------------------------------
  name       | 実行ファイル名         | "hsptmp"
  runtime    | 使用するランタイム     | "hsprt"
  type       | 実行ファイルのタイプ   | 0
             | (0=EXEファイル)        |
             | (1=フルスクリーンEXE)  |
             | (2=スクリーンセーバー) |
  xsize      | 初期ウィンドウXサイズ  | 640
  ysize      | 初期ウィンドウYサイズ  | 480
  hide       | 初期ウィンドウ非表示SW | 0
  orgpath    | 初期ディレクトリ維持SW | 0
  icon       | アイコンファイル設定   | なし
  version    | バージョンリソース設定 | なし
  manifest   | マニフェスト設定       | なし
  lang       | 言語コード設定         | なし
  upx        | UPX圧縮設定            | なし
 ------------------------------------------------------
^p
以下の例では、 「test.scr」というスクリーンセーバーを「hsp2c.hrt」というランタイムを使用して作成します。
^p
例 :
	#packopt type 2
	#packopt name "test"
	#packopt runtime "hsp2c.hrt"
^p
「実行ファイル自動作成」を行なうと、編集中のスクリプトに記述されている#pack,#epack,#packoptの情報を元に、実行ファイルが生成されます。
その際に、「start.ax」はデフォルトで暗号化されたものが追加されます。
「#packopt runtime "ランタイムファイル名"」で指定されたランタイムファイル(拡張子がhrtのもの)は、 hspcmp.dllと同じディレクトリか、または、runtimeディレクトリに置かれているものが使用されます。
icon,version,manifest,lang,upxのキーワードは、実行ファイル生成後にiconinsツールを使用して設定されます。
アイコンファイルは、.ico形式のファイルを指定する必要があります。
^p
例 :
	// 埋め込むアイコンファイルを指定
	#packopt icon "test.ico"
	// 埋め込むバージョン情報を記述したファイルを指定
	#packopt version "test.txt"
	// UPXを使用し圧縮する場合"1"を設定する
	#packopt upx "1"
	// 言語を指定 デフォルトは日本語 (1041)10進数で記述
	#packopt lang "1041"
^p
UPX圧縮を使用する場合は、upx.exe(Win32 console version)をあらかじめダウンロードしてiconinsツールと同じフォルダに配置する必要があります。


%href
#pack
#epack
#cmpopt


%index
#const
マクロ名の定数定義
%group
プリプロセッサ命令
%prm
マクロ名 定数式
%inst
指定されたマクロ名に置換え数値を設定します。
#defineと同様ですが、 #constは定数(数値)の置き換えを行なう場合にあらかじめ計算を行なった結果を置き換えます。
^p
例 :
	#const KAZU 100+50
	a=KAZU
		↓(展開後)
	a=150
^p
あらかじめソース内で使用する値が確定している場合、ソースの高速化に有効です。すでに定義されているマクロを含めることも可能なので、
^p
例 :
	#const ALL 50
	#const KAZU 100*ALL
	a=KAZU
		↓(展開後)
	a=5000
^p
のように使用することができます。
計算式は、整数及び実数を使用することができます。
演算子および数値の記述スタイルは、通常の式と同様のものが使えます。カッコによる順位の指定も可能です。
^
#const命令の直後に「global」を入れることで、すべてのモジュールで永続的に利用することのできるマクロを作成することができます。
^p
例 :
	#module
	#const global test 1234
	#global
	a=test   ; aに1234が代入される
^p
通常は、モジュール内で#constを定義した場合には、それ以外のモジュールおよびグローバルなエリアでは、同じ名前は認識されません。
global指定を入れることで、それ以降のすべての場所で定義した名前をマクロで置き換えることができるようになります。
^
#const命令の直後に「double」を入れることで、 定義されている数値が強制的に実数と認識されます。
この指定を行なわなかった場合には、小数点以下の値があるかどうかによって、整数と実数が自動的に判別されます。

%href
#define
%port+
Let


%index
#undef
マクロ名の取り消し
%group
プリプロセッサ命令
%prm
マクロ名
%inst
すでに登録されているマクロ名を取り消します。
登録されていないマクロ名に対して指定してもエラーにはならず無視されます。
%href
#define
%port+
Let


%index
#if
数値からコンパイル制御
%group
プリプロセッサ命令
%prm
数値式
%inst
コンパイルのON/OFFを指定します。
#ifは指定した数値が 0ならば以降のコンパイル出力をOFFにしてコンパイル結果を無視します(プログラムとして実行されません)。
数値が0以外の場合は、出力がONとなります。
このコンパイル制御は、#endifが出るまでの区間を対象にします。
#if、#ifdef、#ifndefのいずれかには、#endifがペアで存在している必要があります。
^p
例 :
	#if 0
	mes "ABC"       ; この部分は無視されます
	a=111           ; この部分は無視されます
	mes "DEF"       ; この部分は無視されます
	#endif
^p
#ifの指定には式を使うことも可能なので、
^p
例 :
	#define VER 5
	#if VER<3
	mes "ABC"       ; この部分は無視されます
	a=111           ; この部分は無視されます
	mes "DEF"       ; この部分は無視されます
	#endif
^p
のような使い方もできます。計算式の記述および演算子の注意点などは、#const命令と同様です。
また、#if〜#endifのプロックを入れ子にすることも可能です。
^p
例 :
	#ifdef SW
		#ifdef SW2
		mes "AAA"       ; SWとSW2が定義されている場合
		#else
		mes "BBB"       ; SWが定義されている場合
		#endif
	#endif
^p
基本的にCやC++のプリプロセッサに近い使い方ができるようになっています。
プリプロセッサは、通常のコンパイルで自動的に適用されます。
%href
#else
#endif
#ifdef
#ifndef
#define
#const
%port+
Let


%index
#ifdef
マクロ定義からコンパイル制御
%group
プリプロセッサ命令
%prm
マクロ名
%inst
コンパイルのON/OFFを指定します。
#ifdefは指定したマクロが定義されていなければ以降のコンパイル出力をOFFにしてコンパイル結果を無視します。定義されている場合は、出力がONとなります。このコンパイル制御は、#endifが出るまでの区間を対象にします。
コンパイル制御についての詳細は、 #if命令のリファレンスを参照してください。
%href
#if
#ifndef
#else
#endif
%port+
Let


%index
#ifndef
マクロ定義からコンパイル制御2
%group
プリプロセッサ命令
%prm
マクロ名
%inst
コンパイルのON/OFFを指定します。
#ifndefは指定したマクロが定義されていれば以降のコンパイル出力をOFFにしてコンパイル結果を無視します。定義されていない場合は、出力がONとなります。このコンパイル制御は、#endifが出るまでの区間を対象にします。
コンパイル制御についての詳細は、 #if命令のリファレンスを参照してください。
%href
#if
#ifdef
#else
#endif
%port+
Let


%index
#else
コンパイル制御を反転
%group
プリプロセッサ命令
%inst
#if、#ifdef、#ifndefなどのコンパイル制御区間内で、ON/OFFを反転します。
コンパイル制御についての詳細は、 #if命令のリファレンスを参照してください。
%href
#if
#ifdef
#ifndef
#endif
%port+
Let


%index
#endif
コンパイル制御ブロック終了
%group
プリプロセッサ命令
%inst
#if、#ifdef、#ifndefなどのコンパイル制御区間を終了します。
コンパイル制御についての詳細は、 #if命令のリファレンスを参照してください。
%href
#if
#ifdef
#ifndef
#else
%port+
Let



%index
#modfunc
新規命令を割り当てる
%group
プリプロセッサ命令
%prm
p1 p2 p3,…
p1      : 割り当てられる命令の名前
p2 p3〜 : パラメータータイプ名・エイリアス名

%inst
モジュール変数を処理するための新規命令を登録します。
p1に新規命令の名前を、p2以降に呼び出しパラメータタイプを指定します。
命令を定義した位置より以降は、指定された名前を命令語として使用することが可能です。
また、#modfuncのルーチン内では、システム変数thismodを、 自分自身のモジュール変数として扱うことができます。
^
#modfunc命令のパラメーターは、#deffunc命令と同じ形式になります。
#deffunc命令との違いは、呼び出しの際にモジュール型の変数を指定する必要がある点です。モジュール変数の詳細については、プログラミングマニュアル(hspprog.htm)のモジュール項目を参照してください。

%href
#modcfunc
#deffunc
#modinit
#modterm
thismod



%index
#modcfunc
新規関数を割り当てる
%group
プリプロセッサ命令
%prm
p1 p2 p3,…
p1      : 割り当てられる命令の名前
p2 p3〜 : パラメータータイプ名・エイリアス名

%inst
モジュール変数を処理するための新規関数を登録します。
p1に新規命令の名前を、p2以降に呼び出しパラメータタイプを指定します。
命令を定義した位置より以降は、指定された名前を命令語として使用することが可能です。
また、#modcfuncのルーチン内では、システム変数thismodを、 自分自身のモジュール変数として扱うことができます。
^
#modcfunc命令のパラメーターは、#defcfunc命令と同じ形式になります。
#defcfunc命令との違いは、呼び出しの際にモジュール型の変数を指定する必要がある点です。モジュール変数の詳細については、プログラミングマニュアル(hspprog.htm)のモジュール項目を参照してください。

%href
#modfunc
#deffunc
#modinit
#modterm
thismod



%index
#modinit
モジュール初期化処理の登録
%group
プリプロセッサ命令
%prm
p1 p2,…
p1 p2〜 : パラメータータイプ名・エイリアス名

%inst
モジュール変数を初期化するための処理(コンストラクタ)を登録します。
オプションとして呼び出しパラメータタイプ、エイリアス名を指定することができます。
#modinitで定義した区間は、newmod命令実行時に自動的に呼び出されるようになります。
また、newmod命令で指定されたオプションパラメーターを、コンストラクタ側で取得することが可能です。
モジュール変数の詳細については、プログラミングマニュアル(hspprog.htm)のモジュール項目を参照してください。
^
#modinit命令のパラメータータイプ、エイリアス名は、#deffunc命令と同じ形式になります。

%href
#deffunc
#modfunc
#modterm
newmod



%index
#modterm
モジュール解放処理の登録
%group
プリプロセッサ命令
%prm

%inst
モジュール変数を破棄するための処理(デストラクタ)を登録します。
オプションとして呼び出しパラメータタイプ、エイリアス名を指定することができます。
#modtermで定義した区間は、delmod命令実行時かモジュール変数が破棄された時、自動的に呼び出されます。
モジュール変数の詳細については、プログラミングマニュアル(hspprog.htm)のモジュール項目を参照してください。

%href
#deffunc
#modfunc
#modinit
delmod



%index
#regcmd
拡張プラグインの登録
%group
プリプロセッサ命令
%prm
"初期化関数名","DLLファイル名",変数型拡張数
"初期化関数名"  : プラグイン初期化関数のエクスポート名
"DLLファイル名" : プラグイン初期化関数のDLL名
変数型拡張数(0) : プラグインで拡張される変数型の数

%inst
HSP拡張プラグインの登録を行ないます。
初期化関数名は、 DLLからエクスポートされた名前を正確に指定しなければなりません。VC++からエクスポートした場合には、先頭に「_」が、最後に「@4」が付加されるので、それを含めた名前を記述します。(VC++以外のコンパイラで作成されたDLLの場合は、エクスポート名のルールが異なります。詳しくは、それぞれの環境の資料を参照してください。)
たとえば、「hpi3sample.dll」の「hsp3cmdinit」 という関数を登録する場合は、
^p
例 :
	#regcmd "_hsp3cmdinit@4","hpi3sample.dll"
^p
のようになります。
変数型をプラグインにより拡張する場合には、「変数型拡張数」を指定する必要があります。
変数型を１種類追加する場合は、変数型拡張数に１を指定してください。変数型を拡張しない場合は、変数型拡張数は省略するか０を指定してください。変数型拡張数が正しく指定されないと、型の登録は無効になるので注意してください。


%href
#cmd
#uselib
#func


%index
#cmd
拡張キーワードの登録
%group
プリプロセッサ命令
%prm
新規キーワード サブID
新規キーワード : 追加されるキーワード
サブID         : キーワードの与えられるサブID値

%inst
HSP拡張プラグインのためにキーワードの登録を行ないます。
あらかじめ、 #regcmd命令によってプラグイン初期化関数の登録を行なっておく必要があります。
^p
例 :
	#cmd newcmd $000
	#cmd newcmd2 $001
	#cmd newcmd3 $002
^p
上の例では、「newcmd」というキーワードがサブID0として、「newcmd2」というキーワードがサブID1、 「newcmd3」というキーワードがサブID2として登録されます。


%href
#regcmd
#uselib
#func



%index
#usecom
外部COMインターフェースの指定
%group
プリプロセッサ命令
%prm
インターフェース名 "インターフェースIID" "クラスIID"
インターフェース名    : インターフェースを識別するキーワード
"インターフェースIID" : COMのインターフェースを示すIID文字列
"クラスIID"           : COMのクラスを示すIID文字列

%inst
外部コンポーネント(COM)定義を行ないます。
指定したインターフェース名に、クラスIID、インターフェースIIDを割り当てて使用可能な状態にします。
IIDは、レジストリと同様の文字列({〜})で指定することができます。
また、"クラスIID"は省略することができます。
^p
例 :
	#define CLSID_ShellLink "{00021401-0000-0000-C000-000000000046}"
	#define IID_IShellLinkA "{000214EE-0000-0000-C000-000000000046}"
	#usecom IShellLinkA IID_IShellLinkA CLSID_ShellLink
^p
インターフェース名の直前に「global」を入れることで、 すべてのモジュールで永続的に利用することのできるインターフェースを作成することができます。


%href
#comfunc
newcom
delcom
querycom



%index
#comfunc
外部COM呼び出し命令登録
%group
プリプロセッサ命令
%prm
新規名称 インデックス タイプ名1,…
新規名称     : 命令として認識されるキーワード名
インデックス : メソッドindex値
タイプ名     : 引数のタイプを,で区切って指定します

%inst
外部コンポーネント(COM)を呼び出すための新しい命令を登録します。
#comfuncは、 #usecom命令によって指定されたインターフェースのメソッドを命令として呼び出すための登録を行ないます。
以降は、 新規名称で指定された命令とCOMオブジェクト型の変数を組み合わせてコンポーネントを呼び出すことができます。
^
新規名称、インデックス、タイプをスペースで区切って書きます。
新規名称の直前に「global」を入れることで、 すべてのモジュールで永続的に利用することのできる命令を作成することができます。
^
タイプ名には、引数の詳細を記述します。
#deffunc命令と同様に、引数の型を「,」で区切って指定してください。
引数の数や、型の順番に制限はありません。
引数の型として使用できる文字列は以下の通りです。
^p
   型      :  内     容
 -------------------------------------------------------------
   int     :  整数値(32bit)
   var     :  変数のデータポインタ(32bit)
   str     :  文字列ポインタ(32bit)
   wstr    :  unicode文字列ポインタ(32bit)
   double  :  実数値(64bit)
   float   :  実数値(32bit)
   pval    :  PVal構造体のポインタ(32bit)
   bmscr   :  (*)BMSCR構造体のポインタ(32bit)
   hwnd    :  (*)現在選択されているウィンドウのハンドル(HWND)
   hdc     :  (*)現在選択されているウィンドウのデバイスコンテキスト(HDC)
   hinst   :  (*)実行中のHSPインスタンスハンドル
^p
(*)がついている項目は、 引数として指定する必要なく自動的に渡されるパラメーターを示しています。
^p
例 :
	; シェルリンクオブジェクトのクラスID
	#define CLSID_ShellLink "{00021401-0000-0000-C000-000000000046}"
	; IShellLink インターフェースのインターフェースID
	#define IID_IShellLinkA "{000214EE-0000-0000-C000-000000000046}"

	#usecom IShellLinkA IID_IShellLinkA CLSID_ShellLink
	#comfunc IShellLink_SetPath 20 str

	newcom slink, IShellLinkA
	IShellLink_SetPath slink, "c:\\hsp261\\hsp2.exe"
^p
上の例では、IShellLinkAインターフェースのIShellLink_SetPathをslinkという変数とともに呼び出しています。
#comfuncで登録された命令は、最初の引数が常に同じインターフェースを持つCOMオブジェクト型の変数になるので注意してください。

%href
#usecom
newcom
delcom
querycom



%index
#enum
マクロ名の定数を列挙
%group
プリプロセッサ命令
%prm
マクロ名 = p1
マクロ名 : 定数を割り当てるマクロ名
p1       : 割り当てられる定数
%inst
指定されたマクロ名に連続した値を割り当てます。
#const命令と同様に、定数を示すマクロ名を定義することができます。
^p
例 :
	#enum KAZU_A = 0	; KAZU_Aは0になる
	#enum KAZU_B		; KAZU_Bは1になる
	#enum KAZU_C		; KAZU_Cは2になる
	a=KAZU_B
		↓(展開後)
	a=1
^p
マクロ名に続いて「=(イコール)」と数値(または式)を書くことで、 定数が初期化されます。 以降は、#enum命令で定義するたびに数値が１づつ増えていきます。
#enum命令は、連続した値をマクロによって定義したい場合に使用します。
#const命令により、数値をいちいち指定する必要がなく、後から追加や削除が容易になります。

%href
#const
%port+
Let




%index
#runtime
ランタイムファイルの設定
%group
プリプロセッサ命令
%prm
"ランタイム名"
"ランタイム名" : 設定するランタイム名

%inst
スクリプトの実行に使用されるランタイムファイル名を設定します。
(ランタイムファイル名は、   拡張子の除いたファイルの名前部分を指定します。)
スクリプトエディタからの実行時や実行ファイル作成時のランタイムを設定する場合に使用します。
#runtime命令が複数設定された場合は、最後に設定された内容が有効になります。

%href
#packopt
#cmpopt
%port+
Let
%portinfo
HSPLet使用時は、"hsplet3"をランタイム名に指定してください。


%index
#cmpopt
コンパイル時の設定
%group
プリプロセッサ命令
%prm
オプション名  パラメーター
オプション名 : オプションの種類
パラメーター : 設定するパラメーター

%inst
スクリプトコンパイル時の動作を指定します。
オプション名、の後スペース又は TAB を入れてパラメーター
(文字列の場合は「"strings"」のように指定)を記述して下さい。
#cmpoptで指定できるキーワードは以下の通りです。
^p
  オプション |      内      容            | 初期値
 ------------------------------------------------------
  ppout      | プリプロセッサファイル出力 | 0
             | (0=なし/1=出力する)        |
  optcode    | 不要なコードの最適化       | 1
             | (0=なし/1=最適化する)      |
  optinfo    | 最適化の情報ログ出力       | 0
             | (0=なし/1=出力する)        |
  varname    | デバッグ時以外での         | 0
             | 変数名情報の出力           |
             | (0=なし/1=あり)            |
  varinit    | 未初期化変数のチェック     | 0
             | (0=警告/1=エラー)          |
  optprm     | パラメーターコードの最適化 | 1
             | (0=なし/1=最適化する)      |
  skipjpspc  | 全角スペースの無視         | 1
             | (0=エラー/1=無視する)      |
  utf8       | 文字列をUTF-8形式で出力    | 0
             | (0=無効/1=有効)            |
 ------------------------------------------------------
^p
以下の例では、プリプロセッサ結果をファイル出力します。
^p
例 :
	#cmpopt ppout 1
^p
#cmpopt命令は、基本的にスクリプトの先頭に記述してください。
複数の#cmpopt命令が記述されている場合は、それぞれのオプションにおいて最後の設定が有効になります。(#packoptオプションと同様です)
また、特定の範囲だけにオプションを適用するような書き方はできません。

%href
#packopt
#runtime
%port+
Let



%index
#bootopt
ランタイム起動時の設定
%group
プリプロセッサ命令
%prm
オプション名  パラメーター
オプション名 : オプションの種類
パラメーター : 設定するパラメーター

%inst
スクリプトランタイムの細かい動作設定を行ないます。
オプション名、の後スペース又は TAB を入れて設定スイッチ	1か0の数値を記述して下さい。
#bootoptは、スクリプト内の任意の位置に記述することが可能です。
複数の指定があった場合は、最後に設定されたものが全体の設定となります。

#bootoptで指定できるキーワードは以下の通りです。
^p
  オプション |      内      容                | 初期値
 -----------------------------------------------------------
  notimer    | 高精度タイマーの使用           | 自動設定
             | (0=使用する/1=使用しない)      |
  utf8       | UTF-8形式文字列の使用          | 自動設定
             | (0=使用する/1=使用しない)      |
  hsp64      | 64ビットランタイムの使用       | 自動設定
             | (0=使用する/1=使用しない)      |
 -----------------------------------------------------------
^p
以下の例では、高精度タイマーの使用を抑制します。
^p
例 :
	#bootopt notimer 1
^p

%href
#cmpopt
#runtime



%index
#aht
AHTファイルヘッダを記述
%group
プリプロセッサ命令
%prm
設定名 p1
設定名 : 定数を割り当てる設定項目の名前
p1     : 割り当てられる定数
%inst
ソーススクリプトにAHTファイルの情報を付加します。
指定された設定名に文字列または数値を割り当てることができます。
#aht命令により、AHTファイルヘッダが付加されたソーススクリプトは、AHTファイルとして、テンプレートマネージャー等から参照することが可能になります。
設定名として使用できる
^p
  設定名     |      内      容
 ------------------------------------------------------------
  class      | AHTファイルのクラス名を指定します
  name       | AHTファイルの名称を指定します
  author     | AHTファイルの作者名を指定します
  ver        | AHTファイルのバージョンを指定します
  exp        | AHTファイルについての説明を指定します
  icon       | AHTファイル固有のアイコンファイルを指定します
  iconid     | AHTファイル固有のアイコンIDを指定します
 ------------------------------------------------------------
^p
AHTファイルについての詳細は、ドキュメント「Additional HSP Template & Tools」(aht.txt)を参照してください。

%href
#ahtmes
%port+
Let


%index
#ahtmes
AHTメッセージの出力
%group
プリプロセッサ命令
%prm
p1
p1     : 出力される文字列式
%inst
AHTパース時に、外部へのメッセージ出力を行ないます。
主に、「かんたん入力」でエディタ上に追加されるソースコードを記述するために使用しています。
#ahtmes命令は、mes命令と同様に文字列やマクロを「+」演算子で接続させて出力することができます。
^p
例 :
	#define 代入する変数	a	;;str
	#const 乱数の範囲 100		;;help="0から指定範囲-1まで発生します"
	#ahtmes	"	"+代入する変数+" = rnd( "+乱数の範囲+" )\t\t; 変数 "+代入する変数+" に乱数を代入します。"
^p
通常のmes命令と異なり、あくまでもプリプロセッサ上で定義されているマクロを接続するという点に注意してください。
AHTファイルについての詳細は、ドキュメント「Additional HSP Template & Tools」(aht.txt)を参照してください。

%href
#aht
%port+
Let




