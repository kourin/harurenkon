#!ruby -Ks
#sample2.rb
require 'vr/vruby'
require 'vr/vrcontrol'
require "vr/simple_dialog"
include SimpleDialog

#self_dropfiles(files)

 inmovie = SimpleDialog.select_file(title = "動画ファイル選択", filter = [])
 inmovie.each do |line|
 $movie = line
 end
 
 infile = SimpleDialog.select_file(title = "音声ファイル選択", filter = [])
 infile.each do |line|
 $audio = line
end

$runfile = "start main.bat"
$runfile += " "+"\""+$movie+"\""
$runfile += " "+"\""+$audio+"\""

# print $runfile

class MyFiles < VRPanel
  include VRMessageParentRelayer
  def construct
    self.caption="春蓮根"
    b = $movie
    c = $audio
    addControl(VRStatic,     "txt1"," ",  10,10,1200,20)
    addControl(VRButton,     "btn1","動画ファイル選択",  10,30,300,20)
    addControl(VRStatic,     "txt2"," ",  10,50,1200,20)
    addControl(VRButton,     "btn2","音声ファイル選択",  10,70,300,20)
    @txt1.caption  = "動画："
    @txt1.caption += $movie
    @txt2.caption  = "音声："
    @txt2.caption += $audio
    send_parent("btn1",  "clicked")
    send_parent("btn2",  "clicked")
  end
   #    @txt1.caption += $movie
end

#読み込みボタンを押して選択にしたいが、まだできない
#  def btn2_clicked
#    infile = SimpleDialog.select_file(title = "音声ファイル選択", filter = [])
#    infile.each do |line|
#      $audio = line
#    @txt2.caption += $audio
#  end

class MyControl < VRPanel
  include VRMessageParentRelayer
  include VRStdControlContainer
  def construct
    self.caption="春蓮根"
    addControl(VRRadiobutton,     "rdb1","プレミアム会員",  10,10, 150,20)
    addControl(VRRadiobutton,     "rdb2","一般会員 映像重視",  10,30, 200,20)
    addControl(VRRadiobutton,     "rdb3","一般会員 音声重視",  10,50, 200,20)
    addControl(VRRadiobutton,     "rdb4","エコノミー回避（常に同じ画質・音質で再生できるが低画質）",  10,70, 550,20)
    addControl(VRCheckbox,   "chk1","終了時に音で知らせる",    10,90, 750,20)
    @rdb1.check true
    @chk1.check true

    send_parent("rdb1",  "checked")
    send_parent("rdb2",  "checked")
    send_parent("rdb3",  "checked")
    send_parent("rdb4",  "checked")
    send_parent("chk1",  "checked")
   end

end

class StartEnc < VRPanel
  include VRMessageParentRelayer
  include VRStdControlContainer
  def construct
    self.caption="春蓮根"
      addControl(VRButton,     "btn101","エンコード開始",  10,10, 200,20)
      send_parent("btn101",  "clicked")
  end
end


module MyForm
  def construct
    self.caption="my control sample"
     addControl(VRStatic,     "txt3","春蓮根(ニコニコ動画用エンコード支援ツール)",  10,10, 550,20)
     addControl(MyFiles,"cntl0","test", 10,30,800,100,WStyle::WS_BORDER)
     addControl(MyControl,"cntl1","test", 10,130,800,130,WStyle::WS_BORDER)
     addControl(StartEnc,"cntl2","test", 10,270,800,50)
  end

#esound と actypeはエンコード開始ボタンを押した時に値確定→設定ファイルに書き出し、としたいが、まだ動かない
   def cntl1_chk1_checked
    esound = if @cntl1_chk1.checked? then "true" else "false" end
   end

   def cntl1_rdb1_checked
    actype = if @rdb1.checked? then "premium" end
   end

   def cntl1_rdb2_checked
    actype = if @rdb2.checked? then "normalmovie" end
   end

   def cntl1_rdb3_checked
    actype = if @rdb3.checked? then "normalaudio" end
   end

   def cntl1_rdb4_checked
    actype = if @rdb4.checked? then "economy" end
   end

   def cntl2_btn101_clicked
     print esound + "\n"
     print actype + "\n"
     file1 = "haru_enc_start.bat"
     open( file1 , "w"){|f| f.write($runfile)}
     file2 = "haru_enc_setting1.txt"
     open( file2 , "w"){|f| f.write(esound)}
     file3 = "haru_enc_setting2.txt"
     open( file3 , "w"){|f| f.write(actype)}
     close
    `haru_enc_start.bat`
   end   

end


VRLocalScreen.showForm(MyForm,100,100,800,350)
VRLocalScreen.messageloop
