#!ruby -Ks
require 'vr/vruby'
require 'vr/vrcontrol'
#require 'open-uri'
require 'net/http'
require 'uri'
require "vr/simple_dialog"
include SimpleDialog


def vercheck
	url = URI.parse('http://kourindrug.sakura.ne.jp/files/tde/latest_version')
	req = Net::HTTP::Get.new(url.path)
	res = Net::HTTP.start(url.host, url.port) {|http|
	http.request(req)
	}
	@latestver =  res.body

	@verfile = "tool/version.bat"
	@currentverfile = "tool/current_version"
	open(@verfile) {|file|
	@currentver0 = file.readlines[0]
	}

	@currentver1 = @currentver0.split(/\s*\=\s*/)
	@currentver2 = @currentver1.pop
	$currentver = @currentver2.sub(/\n/, '')
    p $currentver
    p @latestver
	str = "Copyright 2001 by TAKEUCHI Hitoshi.".sub(/[A-Za-z]*right/, "Copyleft")
	unless @latestver == $currentver then
	  @updateconfirm = msgbox("新しいバージョンが出ています。今、アップデードしますか？", "アップデード確認", :yesno)
	  if @updateconfirm == :yes then
	    exec('start tool\harurenkon.bat natsurenkonupdate')
	    open( @currentverfile, "w"){|f| f.write(@latestver)}
		exit()
	  else 
	    open( @currentverfile, "w"){|f| f.write(@latestver)}	  
	  end 
    end
end

vercheck

#VRLocalScreen.showForm(MyForm,100,100,800,470)
#VRLocalScreen.messageloop

class MyControl < VRPanel
  include VRMessageParentRelayer
  include VRStdControlContainer
  def construct
    self.caption="春蓮根"
    b = $movie
    c = $audio
    addControl(VRButton,     "btn1","動画または画像ファイルを選択",  10,30,500,20)
    addControl(VRButton,     "btn2","動画とは別の音声を使う場合は音声ファイルを選択",  10,70,500,20)
    addControl(VRStatic,     "txt3","プレミアム会員",  10,110, 500,20)
    addControl(VRRadiobutton,     "rdb1","バランス",  70,130, 150,20)
    addControl(VRStatic,     "txt4","一般会員",  10,150, 500,20)
    addControl(VRRadiobutton,     "rdb2","バランス",  70,170, 200,20)
    addControl(VRRadiobutton,     "rdb3","音質重視",  70,190, 200,20)
    addControl(VRStatic,     "txt5","エコノミー回避（低画質になるかもしれないが、常に同じ画質・音質。\n　　　　　　　　一般会員が混雑時間帯に試聴しても劣化しない）",  10,210, 700,40)
    addControl(VRRadiobutton,     "rdb4","画質重視",  70,250, 800,20)
    addControl(VRRadiobutton,     "rdb5","音質重視（主に画像1枚(+歌詞)の音楽動画向け）",  70,270, 800,20)
    addControl(VRCheckbox,   "chk1","エンコ終了時、音で知らせる",    200,310, 750,20)
    addControl(VRButton,     "btn101","エンコード開始",  200,350, 200,20)
    @rdb1.check true
    @chk1.check true
    send_parent("btn1",  "clicked")
    send_parent("btn2",  "clicked")
    send_parent("rdb1",  "clicked")
    send_parent("rdb2",  "clicked")
    send_parent("rdb3",  "clicked")
    send_parent("rdb4",  "clicked")
    send_parent("rdb5",  "clicked")
    send_parent("chk1",  "clicked")
    send_parent("btn101",  "clicked")
   end
end

module MyForm
  include SimpleDialog
  def construct
    self.caption="春蓮根(夏蓮根簡易フロントエンド)"
     addControl(VRStatic,     "txt0","夏蓮根(ニコニコ動画用エンコード支援ツール)",  100,10, 550,20)
     addControl(MyControl,"cntl1"," ", 10,30,800,390)
     addControl(VRStatic,     "txt1","動画：",  20,40,1200,20)
     addControl(VRStatic,     "txt2","音声：",  20,80,1200,20)

     @file1 = "tool/TEMP/HARU/haru_enc_setting1.txt"
     @file2 = "tool/TEMP/HARU/haru_enc_setting2.txt"
     @file3 = "tool/TEMP/HARU/haru_enc_start.bat"
	 harutitle = "夏蓮根" + $currentver + "  (ニコニコ動画用エンコード支援ツール)"
	 @txt0.caption = harutitle
    unless File.exist?("tool/TEMP/HARU") then
    `mkdir "tool/TEMP/HARU"`
    end
  end

   def cntl1_btn1_clicked
       inmovie = SimpleDialog.select_file(title = "動画または画像ファイルを選択してください", filter = [])
       inmovie
       if not inmovie == nil then
          inmovie.each do |line|
          $movie = line
          @txt1.caption = "動画："+$movie
          end
       end
   end

   def cntl1_btn2_clicked
       inaudio = SimpleDialog.select_file(title = "音声ファイルを選択してください", filter = ["音声ファイル(*.wav;*.mp3)","*.wav;*.mp3"])
       inaudio
       unless inaudio == nil then
          inaudio.each do |line|
          $audio = line
          @txt2.caption = "音声："+$audio
          end
       end
   end

   def cntl1_chk1_clicked
    if File.exist?(@file1) then 
      a=open(@file1).read
    end
    if a == "true" then 
       open( @file1, "w"){|f| f.write("false")}
     else
       open( @file1, "w"){|f| f.write("true")}
     end
   end

   def cntl1_rdb1_clicked
     open( @file2 , "w"){|f| f.write("premium")}
   end

   def cntl1_rdb2_clicked
     open( @file2 , "w"){|f| f.write("normalmovie")}
   end

   def cntl1_rdb3_clicked
     open( @file2 , "w"){|f| f.write("normalaudio")}
   end

   def cntl1_rdb4_clicked
     open( @file2 , "w"){|f| f.write("economymovie")}
   end

   def cntl1_rdb5_clicked
     open( @file2 , "w"){|f| f.write("economyaudio")}
   end

   def cntl1_btn101_clicked
	if not $movie == nil then
		$runfile = 'start tool\harurenkon.bat'
		$runfile += " "+"\""+$movie+"\""
		if not $audio == nil then
			$runfile += " "+"\""+$audio+"\""
		end
		open( @file3 , "w"){|f| f.write($runfile)}
		close
		exec($runfile)
	else
		puts msgbox("エンコードしたいファイルを選択してください", "ファイルを選択してください", :ok)
	end
   end
end

VRLocalScreen.showForm(MyForm,100,100,800,470)
VRLocalScreen.messageloop
