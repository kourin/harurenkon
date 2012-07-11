#!ruby -Ks
require 'vr/vruby'
require 'vr/vrcontrol'
require "vr/simple_dialog"
include SimpleDialog

class MyControl < VRPanel
  include VRMessageParentRelayer
  include VRStdControlContainer
  def construct
    self.caption="春蓮根"
    b = $movie
    c = $audio
    addControl(VRButton,     "btn1","動画または画像ファイルを選択",  10,30,500,20)
    addControl(VRButton,     "btn2","動画とは別の音声を使う場合は音声ファイル選択",  10,70,500,20)
    addControl(VRRadiobutton,     "rdb1","プレミアム会員",  10,110, 150,20)
    addControl(VRRadiobutton,     "rdb2","一般会員 通常",  10,130, 200,20)
    addControl(VRRadiobutton,     "rdb3","一般会員 音声重視",  10,150, 200,20)
    addControl(VRRadiobutton,     "rdb4","エコノミー回避（常に同じ画質・音質で再生できるが低画質。主に画像1枚(+歌詞)の音楽動画向け）",  10,170, 800,20)
    addControl(VRCheckbox,   "chk1","終了時に音で知らせる",    10,210, 750,20)
    addControl(VRButton,     "btn101","エンコード開始",  10,250, 200,20)
    @rdb1.check true
    @chk1.check true
    send_parent("btn1",  "clicked")
    send_parent("btn2",  "clicked")
    send_parent("rdb1",  "clicked")
    send_parent("rdb2",  "clicked")
    send_parent("rdb3",  "clicked")
    send_parent("rdb4",  "clicked")
    send_parent("chk1",  "clicked")
    send_parent("btn101",  "clicked")
   end
end

module MyForm
  include SimpleDialog
  def construct
    self.caption="my control sample"
     addControl(VRStatic,     "txt0","春蓮根(ニコニコ動画用エンコード支援ツール)",  100,10, 550,20)
     addControl(MyControl,"cntl1","test", 10,30,800,320)

     addControl(VRStatic,     "txt1"," ",  20,40,1200,20)
     addControl(VRStatic,     "txt2"," ",  20,80,1200,20)
     @txt1.caption  = "動画："
     @txt2.caption  = "音声："

     @file1 = "tool/HTEMP/haru_enc_setting1.txt"
     @file2 = "tool/HTEMP/haru_enc_setting2.txt"
     @file3 = "tool/HTEMP/haru_enc_start.bat"
  end

   def cntl1_btn1_clicked
       inmovie = SimpleDialog.select_file(title = "動画または画像ファイルを選択してください", filter = [])
       inmovie
       if not inmovie == "nil" then
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
     open( @file2 , "w"){|f| f.write("economy")}
   end

   def cntl1_btn101_clicked
   $runfile = 'start tool\harurenkon.bat'
   $runfile += " "+"\""+$movie+"\""
   if not $audio == nil then
     $runfile += " "+"\""+$audio+"\""
   end
   open( @file3 , "w"){|f| f.write($runfile)}
   close
   exec($runfile)
   end
end

VRLocalScreen.showForm(MyForm,100,100,800,360)
VRLocalScreen.messageloop
