#!ruby -Ks
#sample2.rb
require 'vr/vruby'
require 'vr/vrcontrol'
require "vr/simple_dialog"
include SimpleDialog

#self_dropfiles(files)

 inmovie = SimpleDialog.select_file(title = "����t�@�C���I��", filter = [])
 inmovie.each do |line|
 $movie = line
 end
 
 infile = SimpleDialog.select_file(title = "�����t�@�C���I��", filter = [])
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
    self.caption="�t�@��"
    b = $movie
    c = $audio
    addControl(VRStatic,     "txt1"," ",  10,10,1200,20)
    addControl(VRButton,     "btn1","����t�@�C���I��",  10,30,300,20)
    addControl(VRStatic,     "txt2"," ",  10,50,1200,20)
    addControl(VRButton,     "btn2","�����t�@�C���I��",  10,70,300,20)
    @txt1.caption  = "����F"
    @txt1.caption += $movie
    @txt2.caption  = "�����F"
    @txt2.caption += $audio
    send_parent("btn1",  "clicked")
    send_parent("btn2",  "clicked")
  end
   #    @txt1.caption += $movie
end

#�ǂݍ��݃{�^���������đI���ɂ��������A�܂��ł��Ȃ�
#  def btn2_clicked
#    infile = SimpleDialog.select_file(title = "�����t�@�C���I��", filter = [])
#    infile.each do |line|
#      $audio = line
#    @txt2.caption += $audio
#  end

class MyControl < VRPanel
  include VRMessageParentRelayer
  include VRStdControlContainer
  def construct
    self.caption="�t�@��"
    addControl(VRRadiobutton,     "rdb1","�v���~�A�����",  10,10, 150,20)
    addControl(VRRadiobutton,     "rdb2","��ʉ�� �f���d��",  10,30, 200,20)
    addControl(VRRadiobutton,     "rdb3","��ʉ�� �����d��",  10,50, 200,20)
    addControl(VRRadiobutton,     "rdb4","�G�R�m�~�[����i��ɓ����掿�E�����ōĐ��ł��邪��掿�j",  10,70, 550,20)
    addControl(VRCheckbox,   "chk1","�I�����ɉ��Œm�点��",    10,90, 750,20)
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
    self.caption="�t�@��"
      addControl(VRButton,     "btn101","�G���R�[�h�J�n",  10,10, 200,20)
      send_parent("btn101",  "clicked")
  end
end


module MyForm
  def construct
    self.caption="my control sample"
     addControl(VRStatic,     "txt3","�t�@��(�j�R�j�R����p�G���R�[�h�x���c�[��)",  10,10, 550,20)
     addControl(MyFiles,"cntl0","test", 10,30,800,100,WStyle::WS_BORDER)
     addControl(MyControl,"cntl1","test", 10,130,800,130,WStyle::WS_BORDER)
     addControl(StartEnc,"cntl2","test", 10,270,800,50)
  end

#esound �� actype�̓G���R�[�h�J�n�{�^�������������ɒl�m�聨�ݒ�t�@�C���ɏ����o���A�Ƃ��������A�܂������Ȃ�
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
