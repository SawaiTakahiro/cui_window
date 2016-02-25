#! ruby -Ku

=begin
 2016/02/16
 
 標準出力に整形して表示してみる
=end

require "./library.rb"

MAX_LINE = 5	#１行の文字数
MAX_HEIGHT = 3	#１つのウインドウの最大文字数

#入力用のテキスト。テスト用
text = "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん"

#１行の文字数で分割して、配列に入れる
list_text = text.scan(/.{1,#{MAX_LINE}}/)

#指定したカタマリごとに抜き出して処理する
list_text.each_slice(MAX_HEIGHT) do |list|
	puts list, "*"*20
end