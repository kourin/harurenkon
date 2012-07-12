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
	  @updateconfirm = msgbox("�V�����o�[�W�������o�Ă��܂��B���A�A�b�v�f�[�h���܂����H", "�A�b�v�f�[�h�m�F", :yesno)
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
    self.caption="�t�@��"
    b = $movie
    c = $audio
    addControl(VRButton,     "btn1","����܂��͉摜�t�@�C����I��",  10,30,500,20)
    addControl(VRButton,     "btn2","����Ƃ͕ʂ̉������g���ꍇ�͉����t�@�C����I��",  10,70,500,20)
    addControl(VRStatic,     "txt3","�v���~�A�����",  10,110, 500,20)
    addControl(VRRadiobutton,     "rdb1","�o�����X",  70,130, 150,20)
    addControl(VRStatic,     "txt4","��ʉ��",  10,150, 500,20)
    addControl(VRRadiobutton,     "rdb2","�o�����X",  70,170, 200,20)
    addControl(VRRadiobutton,     "rdb3","�����d��",  70,190, 200,20)
    addControl(VRStatic,     "txt5","�G�R�m�~�[����i��掿�ɂȂ邩������Ȃ����A��ɓ����掿�E�����B\n�@�@�@�@�@�@�@�@��ʉ�������G���ԑтɎ������Ă��򉻂��Ȃ��j",  10,210, 700,40)
    addControl(VRRadiobutton,     "rdb4","�掿�d��",  70,250, 800,20)
    addControl(VRRadiobutton,     "rdb5","�����d���i��ɉ摜1��(+�̎�)�̉��y��������j",  70,270, 800,20)
    addControl(VRCheckbox,   "chk1","�G���R�I�����A���Œm�点��",    200,310, 750,20)
    addControl(VRButton,     "btn101","�G���R�[�h�J�n",  200,350, 200,20)
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
    self.caption="�t�@��(�Ę@���ȈՃt�����g�G���h)"
     addControl(VRStatic,     "txt0","�Ę@��(�j�R�j�R����p�G���R�[�h�x���c�[��)",  100,10, 550,20)
     addControl(MyControl,"cntl1"," ", 10,30,800,390)
     addControl(VRStatic,     "txt1","����F",  20,40,1200,20)
     addControl(VRStatic,     "txt2","�����F",  20,80,1200,20)

     @file1 = "tool/TEMP/HARU/haru_enc_setting1.txt"
     @file2 = "tool/TEMP/HARU/haru_enc_setting2.txt"
     @file3 = "tool/TEMP/HARU/haru_enc_start.bat"
	 harutitle = "�Ę@��" + $currentver + "  (�j�R�j�R����p�G���R�[�h�x���c�[��)"
	 @txt0.caption = harutitle
    unless File.exist?("tool/TEMP/HARU") then
    `mkdir "tool/TEMP/HARU"`
    end
  end

   def cntl1_btn1_clicked
       inmovie = SimpleDialog.select_file(title = "����܂��͉摜�t�@�C����I�����Ă�������", filter = [])
       inmovie
       if not inmovie == nil then
          inmovie.each do |line|
          $movie = line
          @txt1.caption = "����F"+$movie
          end
       end
   end

   def cntl1_btn2_clicked
       inaudio = SimpleDialog.select_file(title = "�����t�@�C����I�����Ă�������", filter = ["�����t�@�C��(*.wav;*.mp3)","*.wav;*.mp3"])
       inaudio
       unless inaudio == nil then
          inaudio.each do |line|
          $audio = line
          @txt2.caption = "�����F"+$audio
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
		puts msgbox("�G���R�[�h�������t�@�C����I�����Ă�������", "�t�@�C����I�����Ă�������", :ok)
	end
   end
end

VRLocalScreen.showForm(MyForm,100,100,800,470)
VRLocalScreen.messageloop
