#! ruby -Ku

=begin
 2016/02/22
 
 標準出力に整形して表示してみる
 昔のドラクエみたいなウインドウっぽく表示してみたい。
 
 シューティングとかのサンプルでよくある、配列でマップを作ってみる的な方法にしてみたバージョン
=end

require "./library.rb"


##################################################

#画面サイズ
WIDTH		= 40
HEIGHT	= 15
DEFAULT_VALUE = " "	#bashだとスペースが省かれるっぽいので、確認用としてアンダーバーにした→windowsのだけ？
CORSOR_UP = "\e[1A"

#罫線の定義
KEISEN_H = "-"
KEISEN_V = "|"
KEISEN_C = "+"

#サイズの上限定義	半角でn文字
MAX_LEN_NAME	= 8
MAX_LEN_STATUS	= 3
DEFALUT_PADDING_CHAR = " "


##################################################
#ステータス、値な表な形にして返す
def get_seikei_status(label, value, padding_char)
	len_label = get_text_length(label.to_s)
	
	#出力用のテキストにどんどん足していく
	text_value = get_text_spaces_padding_r(value, MAX_LEN_STATUS, padding_char)	#右詰めにしておく
	text_line = [KEISEN_C, KEISEN_H * len_label, KEISEN_C, KEISEN_H * MAX_LEN_STATUS, KEISEN_C, "\n"]	#飾り部分
	
	output = Array.new
	output << text_line
	output << [KEISEN_V, label, KEISEN_V, text_value, KEISEN_V, "\n"]
	output << text_line
	
	return output.join
end

#枠線を書き込むやつ
def add_outline(window, start_x, start_y, end_x, end_y)
	#縦横の罫線を入れる
	for i in start_y..end_y do
		window[i][start_x]	= KEISEN_V
		window[i][end_x]	= KEISEN_V
	end
	
	window[start_y].fill(start_x, (end_x - start_x)){KEISEN_H}
	window[end_y].fill(start_x, (end_x - start_x)){KEISEN_H}
	
	
	#TODO:間の部分を水平、垂直の罫線入れる
	window[start_y][start_x]	= KEISEN_C
	window[start_y][end_x]		= KEISEN_C
	
	window[end_y][start_x]		= KEISEN_C
	window[end_y][end_x]		= KEISEN_C
	
	return window
end



#画面の定義（初期化）
#http://blog.cototoco.net/work/201405/ruby-%E9%85%8D%E5%88%97/	参考：オブジェクトIDが同じになってひどいことになる。
window = Array.new(HEIGHT, DEFAULT_VALUE).map{Array.new(WIDTH, DEFAULT_VALUE)}


#以下は、ためしに書き込んでみるデータ
table_name = <<"EOS"
+------+
|さわい|
+------+
EOS

#外枠を描く
#更新はあんまりしないだろうから、メインループに入れない
window = add_outline(window, 0, 0, WIDTH - 1, HEIGHT - 1)

window = add_outline(window, 10, 5, 30, 10)


#メインループ
for i in 0..4 do
	attack = i	#仮で入れてる
	table_attack = get_seikei_status(" atk ", attack, "0")
	
	#画面の内容を更新していく
	window = add_window(table_name, window, 3, 0)
	window = add_window(table_attack, window, 10, 0)
	
	
	#TODO:ここもやりかたを何とかする
	#まだ書き込んでないのにカーソル位置を戻していたから、ぐわーって表示されてた
	#２回目以降だけやるようにする
	print CORSOR_UP * HEIGHT, "\r"	if i > 0
	
	#表示してみる
	window.each do |row|
		p row.join
	end
	sleep 0.1
end

