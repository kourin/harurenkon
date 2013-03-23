#!ruby -Ks
require 'vr/vruby'
require 'net/http'
require 'vr/simple_dialog'
require 'vr/vrcontrol'
require 'vr/vrlayout'
require 'vr/vrddrop'
require 'vr/vrolednd'
require 'vr/vrhandler'
include SimpleDialog

if defined? ExerbRuntime
  basedir =  File.dirname(ExerbRuntime.filepath)
end

def filelistmake
  unless ARGV[0] == nil then
    if File.directory?(ARGV[0]) == false then
        while line = ARGF.gets
          movie1=ARGF.path
        if /(wav|mp3)$/i =~ movie1 then 
            $audio = "\""+ movie1 + "\""
        elsif
           begin
             unless movie1 == nil then
              $movie = $movie + " " + "\""+ movie1 + "\""
             end
           rescue
             $movie = "\""+ movie1 + "\""
           else
           end
        end 
        ARGF.skip
      end
    elsif File.directory?(ARGV[0]) == true then
      $movie = "\""+ ARGV[0] + "\""
    end
  end
end

filelistmake
Dir.chdir(basedir)

class DropPanel < VRPanel
  include VROleDropTarget
  include VRDropFileTarget
  def construct
    addControl VRStatic,"label","", 0,0,500,200
    start_oledroptarget([CF_HDROP])
  end
  
  def self_dropfiles(files)
    1.upto(files.size-1) do |i|
    print files[i]
        if /(wav|mp3)$/i =~ files[i] then 
            $audio = "\""+ movie1 + "\""
        elsif
           begin
             unless files[i] == nil then
              $movie = $movie + " " + "\""+ files[i] + "\""
             end
           rescue
             $movie = "\""+ files[i] + "\""
           else
           end
        end 
    end
  end
end

def vercheck
	@verfile = "tool/version.bat"
	@currentverfile = "tool/current_version"
	open(@verfile) {|file|
	@currentver0 = file.readlines[0]
	}
	@currentver1 = @currentver0.split(/\s*\=\s*/)
	@currentver2 = @currentver1.pop
	$currentver = @currentver2.sub(/\n/, '')

	@latestverfile = "tool/latest_version"

	begin
    unless File.exist?("tool/debug.txt")
	    url = URI.parse('http://kourindrug.sakura.ne.jp/files/tde/latest_version')
    else 
	    url = URI.parse('http://kourindrug.sakura.ne.jp/files/tde/latest_version2')
    end
		req = Net::HTTP::Get.new(url.path)
		res = Net::HTTP.start(url.host, url.port) {|http|
		http.request(req)
		}
	rescue
    	@latestver = $currentver
	else
		@latestver1 =  res.body
    	@latestver = @latestver1.sub(/\n/, '')
	    open( @latestverfile, "w"){|f| f.write(@latestver)}
	end

	unless @latestver == $currentver then
		begin
			url2 = URI.parse('http://dl.dropbox.com/u/9397178/ChangeLog')
			req2 = Net::HTTP::Get.new(url2.path)
			res2 = Net::HTTP.start(url2.host, url2.port) {|http|
			http.request(req2)
			}
		rescue
			@chagngelog = " "
		else
#			@chagngelog =  res2.body.gsub("\n","\r\n")
			@chagngelog =  res2.body
		end
	
	  @updatemassage = @chagngelog + "\r\n###########################\r\n\r\n新しいバージョンが出ています。今、アップデードしますか？"
	  @updateconfirm = msgbox(@updatemassage, "アップデード確認", :yesno)
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

class MyControl < VRPanel
  include VRMessageParentRelayer
  include VRStdControlContainer
  include VRDropFileTarget
  def construct
    self.caption="春蓮根"
    b = $movie
    c = $audio
    addControl(VRButton,     "btn1","動画または画像ファイルを選択",  10,30,500,20)
    addControl(VRButton,     "btn2","動画とは別の音声を使う場合は音声ファイルを選択",  10,70,500,20)
    addControl(VRStatic,     "txt7","※複数ファイルの連続エンコおよび連番aviの連結はタイトルバーへファイルまたはフォルダをドロップ",  10,90, 900,20)
    addControl(VRStatic,     "txt6","簡易設定",  200,130, 120,20)
    addControl(VRStatic,     "txt3","プレミアム会員",  10,150, 500,20)
    addControl(VRRadiobutton,     "rdb1","バランス（9分未満の場合は、画質を重視したい時もこちらを推奨）",  70,170, 550,20)
    addControl(VRRadiobutton,     "rdb2","画質重視（9分を越える動画向け）",  70,190, 500,20)
    addControl(VRStatic,     "txt4","一般会員",  10,210, 500,20)
    addControl(VRRadiobutton,     "rdb3","バランス",  70,230, 200,20)
    addControl(VRRadiobutton,     "rdb4","音質重視",  70,250, 200,20)
    addControl(VRStatic,     "txt5","エコノミー回避（低画質になるかもしれないが、常に同じ画質・音質\n　　　　　　　　一般会員が混雑時間帯に試聴しても劣化しない）",  10,270, 700,40)
    addControl(VRRadiobutton,     "rdb5","画質重視",  70,310, 800,20)
    addControl(VRRadiobutton,     "rdb6","音質重視（主に画像1枚(+歌詞)の音楽動画向け）",  70,330, 800,20)
    addControl(VRCheckbox,   "chk1","エンコ終了時、音で知らせる",    200,370, 300,20)
    addControl(VRButton,     "btn101","エンコード開始",  200,410, 200,20)
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
  include VRDropFileTarget
  def construct
    self.caption="春蓮根(夏蓮根簡易フロントエンド)    ※※※ファイルまたはフォルダをドロップする場合はこのタイトルバーへ※※※"
     addControl(VRStatic,     "txt0","夏蓮根(ニコニコ動画用エンコード支援ツール)",  100,10, 550,20)
     addControl(MyControl,"cntl1"," ", 10,30,800,430)
     addControl(VRStatic,     "txt1","動画：",  20,40,1200,20)
     addControl(VRStatic,     "txt2","音声：",  20,80,1200,20)
     @file1 = "tool/TEMP/HARU/haru_enc_setting1.txt"
     @file2 = "tool/TEMP/HARU/haru_enc_setting2.txt"
     @file3 = "tool/TEMP/HARU/haru_enc_start.bat"
	 harutitle = "夏蓮根" + $currentver + "  (ニコニコ動画用エンコードツール「つんでれんこ」改造版)"
	 @txt0.caption = harutitle
    unless File.exist?("tool/TEMP/HARU") then
    `mkdir "tool/TEMP/HARU"`
    end
    
    unless $movie == nil then 
      @txt1.caption = "動画：" + $movie
    end
    unless $audio == nil then 
      @txt2.caption = "音声：" + $audio
    end
  end

  def textset(fname)
    a=fname
    unless $movie == nil then
      if /(wav|mp3)$/i =~ a then 
        $audio = "\""+ a + "\""
        @txt2.caption = "音声：" + $audio
      else
        $movie = $movie + " \"" + a + "\""
	      @txt1.caption = "動画：" + $movie
      end
    else
        $movie = "\"" + a + "\""
	      @txt1.caption = "動画：" + $movie
    end
  end

  def self_dropfiles(files)
    textset(files[0])
    1.upto(files.size-1) do |i|
    end
  end

   def cntl1_btn1_clicked
       inmovie = SimpleDialog.select_file(title = "動画または画像ファイルを選択してください", filter = [])
       if not inmovie == nil then
          inmovie.each do |line|
          $movie = "\""+ line + "\""
	      @txt1.caption = "動画："+$movie
          end
       end
	   begin 
       ext_name = File.extname( $movie )
	   rescue
	   else
	       if ext_name == ".mswmm" then
	         puts msgbox("これはプロジェクトファイルです。\nWindowsムービーメーカーで「ムービーの発行」をしてwmvファイルにしてください", "プロジェクトファイル エラー", :ok)
	       elsif ext_name == ".wlmp" then
		     puts msgbox("これはプロジェクトファイルです。\nWindows Liveムービーメーカーで「ムービーの保存」をしてwmvファイルにしてください", "プロジェクトファイル エラー", :ok)
	       elsif ext_name == ".aup" then
	         puts msgbox("これはプロジェクトファイルです。\nAviUtlで	「AVI出力」をしてaviファイルにしてください","プロジェクトファイル エラー",  :ok)
	       elsif ext_name == ".vsp" then
	         puts msgbox("これはプロジェクトファイルです。\nVideoStudioで「ビデオファイルの作成」を選んで動画ファイルにしてください ","プロジェクトファイル エラー",  :ok)
	       end
	   end
   end

   def cntl1_btn12_clicked
       inmovie = SimpleDialog.select_directory(title = "連番aviの入ったフォルダを選択してください")
       if not inmovie == nil then
          inmovie.each do |line|
          $movie = "\""+ line + "\""
	      @txt1.caption = "動画："+$movie
          end
       end
   end

   def cntl1_btn2_clicked
       inaudio = SimpleDialog.select_file(title = "音声ファイルを選択してください", filter = ["音声ファイル(*.wav;*.mp3)","*.wav;*.mp3"])
       inaudio
       unless inaudio == nil then
          inaudio.each do |line|
#          $audio = line
          $audio = "\""+ line + "\""
          @txt2.caption = "音声："+ $audio
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
     open( @file2 , "w"){|f| f.write("premiummovie")}
   end

   def cntl1_rdb3_clicked
     open( @file2 , "w"){|f| f.write("normalmovie")}
   end

   def cntl1_rdb4_clicked
     open( @file2 , "w"){|f| f.write("normalaudio")}
   end

   def cntl1_rdb5_clicked
     open( @file2 , "w"){|f| f.write("economymovie")}
   end

   def cntl1_rdb6_clicked
     open( @file2 , "w"){|f| f.write("economyaudio")}
   end

   def cntl1_btn100_clicked
	if not $movie == nil then
		VRLocalScreen.showForm(MyForm2,100,100,800,490)
	else
		puts msgbox("エンコードしたいファイルを選択してください", "ファイルを選択してください", :ok)
	end
   end

   def cntl1_btn101_clicked
	if not $movie == nil then
		$runfile = 'start tool\harurenkon.bat'
#		$runfile += " "+"\""+$movie+"\""
		$runfile += " "+$movie
		if not $audio == nil then
#			$runfile += " "+"\""+$audio+"\""
			$runfile += " "+ $audio
		end
		open( @file3 , "w"){|f| f.write($runfile)}
		close
		exec($runfile)
	else
		puts msgbox("エンコードしたいファイルを選択してください", "ファイルを選択してください", :ok)
	end
   end
end

VRLocalScreen.showForm(MyForm,100,100,800,510)
VRLocalScreen.messageloop
