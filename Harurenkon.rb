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

basedir = Dir.getwd

def filelistmake
  unless ARGV[0] == nil then
    if File.directory?(ARGV[0]) == false then
        while line = ARGF.gets
          movie1=ARGF.path
        if /(wav|mp3|m4a|aac)$/i =~ movie1 then 
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
            $audio = "\""+ files[i] + "\""
        else
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
			url2 = URI.parse('http://kourindrug.sakura.ne.jp/files/tde/ChangeLog')
			req2 = Net::HTTP::Get.new(url2.path)
			res2 = Net::HTTP.start(url2.host, url2.port) {|http|
			http.request(req2)
			}
		rescue
			@chagngelog = " "
		else
			@chagngelog =  res2.body
		end
	
	  @updatemassage = @chagngelog + "\r\n###########################\r\n\r\n�V�����o�[�W�������o�Ă��܂��B���A�A�b�v�f�[�h���܂����H"
	  @updateconfirm = msgbox(@updatemassage, "�A�b�v�f�[�h�m�F", :yesno)
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
    self.caption="�t�@��"
    b = $movie
    c = $audio
    addControl(VRButton,     "btn1","����܂��͉摜�t�@�C����I��",  10,30,500,20)
    addControl(VRButton,     "btn2","����Ƃ͕ʂ̉������g���ꍇ�͉����t�@�C����I��",  10,70,500,20)
    addControl(VRStatic,     "txt7","�������t�@�C���̘A���G���R����јA��avi�̘A���͂��̃E�B���h�E�Ƀt�@�C���܂��̓t�H���_���h���b�v",  10,90, 900,20)
    send_parent("btn1",  "clicked")
    send_parent("btn2",  "clicked")
   end
end

module MyForm
  include VRDropFileTarget
  def construct
    self.caption="�t�@��(�Ę@���ȈՃt�����g�G���h)    �������t�@�C���܂��̓t�H���_���h���b�v����ꍇ�͂��̃^�C�g���o�[�ց�����"
     addControl(VRStatic,     "txt0","�Ę@��(�j�R�j�R����p�G���R�[�h�x���c�[��)",  100,10, 550,20)
     addControl(MyControl,"cntl1"," ", 10,30,800,110)
     addControl(VRStatic,     "txt1","����F",  20,40,1200,20)
     addControl(VRStatic,     "txt2","�����F",  20,80,1200,20)
     addControl(VRStatic,     "txt3","�ȈՐݒ�",  210,160, 120,20)
     addControl(VRStatic,     "txt4","�v���~�A�����",  20,180, 500,20)
     addControl(VRRadiobutton,     "rdb1","�o�����X�i9�������̏ꍇ�́A�掿���d������������������𐄏��j",  80,200, 550,20)
     addControl(VRRadiobutton,     "rdb2","�掿�d���i9�����z���铮������B�܂��́A�o�����X���Əd������ꍇ�p�j",  80,220, 600,20)
     addControl(VRStatic,     "txt5","��ʉ��",  20,240, 500,20)
     addControl(VRRadiobutton,     "rdb3","�o�����X",  80,260, 200,20)
     addControl(VRRadiobutton,     "rdb4","�����d��",  80,280, 200,20)
     addControl(VRStatic,     "txt6","�G�R�m�~�[����i��掿�ɂȂ邩������Ȃ����A��ɓ����掿�E����\n�@�@�@�@�@�@�@�@��ʉ�������G���ԑтɎ������Ă��򉻂��Ȃ��j",  20,300, 700,40)
     addControl(VRRadiobutton,     "rdb5","�掿�d��",  80,340, 800,20)
     addControl(VRRadiobutton,     "rdb6","�����d���i��ɉ摜1��(+�̎�)�̉��y��������j",  80,360, 800,20)
     addControl(VRStatic,     "txt7","YouTube�����ݒ�(�A�b�v���[�h����������Ă��Ȃ��ꍇ��15���܂�)", 20,400, 700,20)
     addControl(VRRadiobutton,     "rdb7","���掿�E�������ɂ��������́A1280x720��1920x1080�ō���Ă�������",  80,420, 800,20)
     addControl(VRStatic,     "txt8","1GB�ȉ���mp4��wmv���́A�G���R�����ɒ��ړ��e�����ق����ǂ������H",  100,440, 800,20)
     addControl(VRCheckbox,   "chk1","�{�C�X�Đ��ƃG���R�I�����̂��m�点���I�t�ɂ���",    150,480, 400,20)
     addControl(VRButton,     "btn101","�G���R�[�h�J�n",  210,520, 200,20)
     @rdb1.check true
     @chk1.check false
     @file1 = "tool/TEMP/HARU/haru_enc_setting1.txt"
     @file2 = "tool/TEMP/HARU/haru_enc_setting2.txt"
     @file3 = "tool/TEMP/HARU/haru_enc_start.bat"
	 harutitle = "�Ę@��" + $currentver + "  (�j�R�j�R����p�G���R�[�h�c�[���u��ł�񂱁v������)"
	 @txt0.caption = harutitle
    unless File.exist?("tool/TEMP/HARU") then
    `mkdir "tool/TEMP/HARU"`
    end
    
    open( @file1, "w"){|f| f.write("true")}
    unless $movie == nil then 
      @txt1.caption = "����F" + $movie
    end
    unless $audio == nil then 
      @txt2.caption = "�����F" + $audio
    end
  end

  def textset(fname)
    a=fname
    if $movie == nil then
      if /(wav|mp3|m4a|aac)$/i =~ a then 
        $audio = "\""+ a + "\""
        @txt2.caption = "�����F" + $audio
      else
        $movie = "\"" + a + "\""
	      @txt1.caption = "����F" + $movie
      end
    else
      if /(wav|mp3|m4a|aac)$/i =~ a then 
        $audio = "\""+ a + "\""
        @txt2.caption = "�����F" + $audio
      else
        $movie = $movie + " \"" + a + "\""
	      @txt1.caption = "����F" + $movie
      end
    end
  end

  def self_dropfiles(files)
    textset(files[0])
    1.upto(files.size-1) do |i|
    end
  end

   def cntl1_btn1_clicked
       inmovie = SimpleDialog.select_file(title = "����܂��͉摜�t�@�C����I�����Ă�������", filter = [])
       if not inmovie == nil then
          inmovie.each do |line|
          $movie = "\""+ line + "\""
	      @txt1.caption = "����F"+$movie
          end
       end
	   begin 
       ext_name = File.extname( $movie )
	   rescue
	   else
	       if ext_name == ".mswmm" then
	         puts msgbox("����̓v���W�F�N�g�t�@�C���ł��B\nWindows���[�r�[���[�J�[�Łu���[�r�[�̔��s�v������wmv�t�@�C���ɂ��Ă�������", "�v���W�F�N�g�t�@�C�� �G���[", :ok)
	       elsif ext_name == ".wlmp" then
		     puts msgbox("����̓v���W�F�N�g�t�@�C���ł��B\nWindows Live���[�r�[���[�J�[�Łu���[�r�[�̕ۑ��v������wmv�t�@�C���ɂ��Ă�������", "�v���W�F�N�g�t�@�C�� �G���[", :ok)
	       elsif ext_name == ".aup" then
	         puts msgbox("����̓v���W�F�N�g�t�@�C���ł��B\nAviUtl��	�uAVI�o�́v������avi�t�@�C���ɂ��Ă�������","�v���W�F�N�g�t�@�C�� �G���[",  :ok)
	       elsif ext_name == ".vsp" then
	         puts msgbox("����̓v���W�F�N�g�t�@�C���ł��B\nVideoStudio�Łu�r�f�I�t�@�C���̍쐬�v��I��œ���t�@�C���ɂ��Ă������� ","�v���W�F�N�g�t�@�C�� �G���[",  :ok)
	       elsif ext_name == ".nvp2" then
	         puts msgbox("����̓v���W�F�N�g�t�@�C���ł��B\n����t�@�C���ɂ��Ă������� ","�v���W�F�N�g�t�@�C�� �G���[",  :ok)
	       elsif ext_name == ".nmm" then
	         puts msgbox("����̓v���W�F�N�g�t�@�C���ł��B\n����t�@�C���ɂ��Ă������� ","�v���W�F�N�g�t�@�C�� �G���[",  :ok)
	       end
	   end
   end

   def cntl1_btn12_clicked
       inmovie = SimpleDialog.select_directory(title = "�A��avi�̓������t�H���_��I�����Ă�������")
       if not inmovie == nil then
          inmovie.each do |line|
          $movie = "\""+ line + "\""
	      @txt1.caption = "����F"+$movie
          end
       end
   end

   def cntl1_btn2_clicked
       inaudio = SimpleDialog.select_file(title = "�����t�@�C����I�����Ă�������", filter = ["�����t�@�C��(*.wav;*.mp3;*.m4a;*.aac)","*.wav;*.mp3;*.m4a;*.aac"])
       inaudio
       unless inaudio == nil then
          inaudio.each do |line|
#          $audio = line
          $audio = "\""+ line + "\""
          @txt2.caption = "�����F"+ $audio
          end
       end
   end

   def chk1_clicked
    if File.exist?(@file1) then 
      a=open(@file1).read
       open( @file1, "w"){|f| f.write("false")}
    end
    if a == "true" then 
       open( @file1, "w"){|f| f.write("false")}
     else
       open( @file1, "w"){|f| f.write("true")}
     end
   end
  
   def rdb1_clicked
     open( @file2 , "w"){|f| f.write("premium")}
   end

   def rdb2_clicked
     open( @file2 , "w"){|f| f.write("premiummovie")}
   end

   def rdb3_clicked
     open( @file2 , "w"){|f| f.write("normalmovie")}
   end

   def rdb4_clicked
     open( @file2 , "w"){|f| f.write("normalaudio")}
   end

   def rdb5_clicked
     open( @file2 , "w"){|f| f.write("economymovie")}
   end

   def rdb6_clicked
     open( @file2 , "w"){|f| f.write("economyaudio")}
   end

   def rdb7_clicked
     open( @file2 , "w"){|f| f.write("youtube")}
   end

   def btn101_clicked
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
		puts msgbox("�G���R�[�h�������t�@�C����I�����Ă�������", "�t�@�C����I�����Ă�������", :ok)
	end
   end
end

VRLocalScreen.showForm(MyForm,100,100,800,590)
VRLocalScreen.messageloop
