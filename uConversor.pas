unit uConversor;

interface
uses
  Classes,Vcl.imaging.pngimage, Vcl.imaging.jpeg, Vcl.Graphics,
  SysUtils, Vcl.Dialogs;

type
 TConversor = record
   LocArquivos       : TStringList;
   LocDestino        : String;
   nomeAuxiliar      : String;
   fmtOrigem         : integer;
   fmtDestino        : integer;
   fundo             : boolean;
   cor               : TColor;
   deleteArqOrigem   : Boolean;
   geraNovoArquivo   : Boolean;

 public
   constructor create(LocalArquivos     : TStringList;
                      localDestino      : string;
                      nomeAux           : string;
                      formatoOrigem     : integer;
                      formatoDestino    : integer;
                      aplicarFundo      : boolean;
                      deletarArqOrigem  : Boolean;
                      gerarNovoArquivo  : Boolean;
                      corFundo          : TColor
                       );


    function formatoValido(arquivo : string; formato : integer): Boolean;
    procedure Converter();
 private

    procedure ConverterPngToJpeg(arquivo : String; destino, nomeAux : string;
deletar, geraNovo, aplicaFundo : Boolean; corFundo : TColor);

    procedure ConverterPngToBmp(arquivo : String; destino, nomeAux : string;
deletar, geraNovo, aplicaFundo : Boolean; corFundo : TColor);

    procedure ConverterJpegToPng(arquivo : String; destino, nomeAux : string;
deletar, geraNovo : Boolean);

    procedure ConverterJpegToBmp(arquivo : String; destino, nomeAux : string;
deletar, geraNovo : Boolean);

 end;

var
 conversor : TConversor;


implementation

{ TConversor }

procedure TConversor.Converter;
var
  I: Integer;
  arquivo : String;
begin
  {FORMATOS 0 - JPG / JPEG |  1 - PNG | 2 - BMP}

  for I := 0 to LocArquivos.Count-1 do
  begin
    arquivo := LocArquivos[i];
    if (formatoValido(arquivo,fmtOrigem)) then
    begin
      //   PNG para JPG-JPEG
      if ((fmtOrigem = 1) and (fmtDestino = 0)) then
        ConverterPngToJpeg(arquivo,LocDestino,nomeAuxiliar,deleteArqOrigem,geraNovoArquivo, fundo,cor)
      // PNG para BMP.
      else if ((fmtOrigem = 1) and (fmtDestino = 2)) then
        ConverterPngToBmp(arquivo,LocDestino,nomeAuxiliar,deleteArqOrigem,geraNovoArquivo, fundo,cor)
        // JPG-JPEG para PNG
        else if ((fmtOrigem = 0) and (fmtDestino = 1)) then
          ConverterJpegToPng(arquivo,LocDestino,nomeAuxiliar,deleteArqOrigem,geraNovoArquivo)
         // JPG-JPEG paraBMP
         else if ((fmtOrigem = 0) and (fmtDestino = 2)) then
          ConverterJpegToBmp(arquivo,LocDestino,nomeAuxiliar,deleteArqOrigem,geraNovoArquivo);

    end;

  end;

end;


procedure TConversor.ConverterJpegToBmp(arquivo, destino, nomeAux: string; deletar,
  geraNovo: Boolean);
var
 jpg : TJPEGImage;
 componente : TPicture;
 bit : TBitmap;
 verificador : Boolean;
 nomeArquivo : String;
begin
  verificador := false;
  try
   jpg := TJPEGImage.Create;
   bit :=  TBitmap.Create;
   componente := TPicture.Create;

   componente.LoadFromFile(arquivo);
   jpg.LoadFromFile(arquivo);

   try
    bit.Width := jpg.Width;
    bit.Height := jpg.Height;
    bit.Canvas.Draw(0,0, componente.Graphic);


    if (pos(UpperCase(ExtractFileExt((arquivo))), UpperCase(ExtractFileName(arquivo))) <> 0) then
    begin
      nomeArquivo := Copy(ExtractFileName(arquivo),0, pos(UpperCase(ExtractFileExt((arquivo))), UpperCase(ExtractFileName(arquivo)))-1);
    end;

    destino := destino + '\' +  nomeArquivo + trim(nomeAux);

    if not (deletar) then
     if ((trim(nomeAux) = '') and (geraNovo)) then
      destino := destino + '_BMP';

    bit.SaveToFile(ChangeFileExt(destino,'.BMP'));
    verificador := true;
   except
    on E: Exception do
    begin
      ShowMessage('Erro: ' + E.Message);
    end;

   end;
   if ((verificador) and (deletar)) then
    DeleteFile(arquivo);


  finally
    FreeAndNil(jpg);
    FreeAndNil(bit);
    FreeAndNil(componente);
  end;
end;

procedure TConversor.ConverterJpegToPng(arquivo, destino, nomeAux: string; deletar,
  geraNovo: Boolean);
var
 png : TPngImage;
 jpg : TJPEGImage;
 componente : TPicture;
 bit : TBitmap;
 verificador : Boolean;
 nomeArquivo : String;
begin
  verificador := false;
  try
   png := TPngImage.Create;
   bit :=  TBitmap.Create;
   jpg := TJPEGImage.Create;
   componente := TPicture.Create;

   componente.LoadFromFile(arquivo);
   jpg.LoadFromFile(arquivo);

   try
    bit.Width := jpg.Width;
    bit.Height := jpg.Height;
    bit.Canvas.Draw(0,0, componente.Graphic);

    png.Assign(bit);


    if (pos(UpperCase(ExtractFileExt((arquivo))), UpperCase(ExtractFileName(arquivo))) <> 0) then
    begin
      nomeArquivo := Copy(ExtractFileName(arquivo),0, pos(UpperCase(ExtractFileExt((arquivo))), UpperCase(ExtractFileName(arquivo)))-1);
    end;

    destino := destino + '\' +  nomeArquivo + trim(nomeAux);

    if not (deletar) then
     if ((trim(nomeAux) = '') and (geraNovo)) then
      destino := destino + '_PNG';


    png.SaveToFile(ChangeFileExt(destino,'.PNG'));
    verificador := true;
   except
    on E: Exception do
    begin
      ShowMessage('Erro: ' + E.Message);
    end;
   end;
   if ((verificador) and (deletar)) then
    DeleteFile(arquivo);


  finally
    FreeAndNil(png);
    FreeAndNil(bit);
    FreeAndNil(jpg);
    FreeAndNil(componente);
  end;
end;

procedure TConversor.ConverterPngToBmp(arquivo, destino, nomeAux: string; deletar,
  geraNovo, aplicaFundo: Boolean; corFundo : TColor);
var
 png : TPngImage;
 componente : TPicture;
 bit : TBitmap;
 verificador : Boolean;
 nomeArquivo : String;
begin
  verificador := false;
  try
   png := TPngImage.Create;
   bit :=  TBitmap.Create;
   componente := TPicture.Create;

   componente.LoadFromFile(arquivo);
   png.LoadFromFile(arquivo);

   try
    bit.Width := png.Width;
    bit.Height := png.Height;

    if (aplicaFundo) then
    begin
      bit.Canvas.Brush.Color := corFundo;
      bit.Canvas.Pen.Color := corFundo;
      bit.Canvas.Rectangle(30,30, png.Width, png.Height+10);
    end;

    bit.Canvas.Draw(0,0, componente.Graphic);


    if (pos(UpperCase(ExtractFileExt((arquivo))), UpperCase(ExtractFileName(arquivo))) <> 0) then
    begin
      nomeArquivo := Copy(ExtractFileName(arquivo),0, pos(UpperCase(ExtractFileExt((arquivo))), UpperCase(ExtractFileName(arquivo)))-1);
    end;

    destino := destino + '\' +  nomeArquivo + trim(nomeAux);

    if not (deletar) then
     if ((trim(nomeAux) = '') and (geraNovo)) then
      destino := destino + '_BMP';

    bit.SaveToFile(ChangeFileExt(destino,'.BMP'));
    verificador := true;
   except
    on E: Exception do
    begin
      ShowMessage('Erro: ' + E.Message);
    end;
   end;
   if ((verificador) and (deletar)) then
    DeleteFile(arquivo);


  finally
    FreeAndNil(png);
    FreeAndNil(bit);
    FreeAndNil(componente);
  end;

end;

procedure TConversor.ConverterPngToJpeg(arquivo : String; destino, nomeAux : string;
deletar, geraNovo, aplicaFundo : Boolean; corFundo : TColor);
var
 png : TPngImage;
 jpg : TJPEGImage;
 componente : TPicture;
 bit : TBitmap;
 verificador : Boolean;
 nomeArquivo : string;
begin
  verificador := false;
  try
   png := TPngImage.Create;
   jpg := TJPEGImage.Create;
   bit :=  TBitmap.Create;
   componente := TPicture.Create;

   componente.LoadFromFile(arquivo);
   png.LoadFromFile(arquivo);

   try
    bit.Width := png.Width;
    bit.Height := png.Height;

    if (aplicaFundo) then
    begin
      bit.Canvas.Brush.Color := corFundo;
      bit.Canvas.Pen.Color := corFundo;
      bit.Canvas.Rectangle(30,30, png.Width, png.Height+10);
    end;
    bit.Canvas.Draw(0,0, componente.Graphic);
    jpg.Assign(bit);

    if (pos(UpperCase(ExtractFileExt((arquivo))), UpperCase(ExtractFileName(arquivo))) <> 0) then
    begin
      nomeArquivo := Copy(ExtractFileName(arquivo),0, pos(UpperCase(ExtractFileExt((arquivo))), UpperCase(ExtractFileName(arquivo)))-1);
    end;

    destino := destino + '\' +  nomeArquivo + trim(nomeAux);
    ShowMessage(destino + ' destino');
    ShowMessage(nomeArquivo + ' nome arquivo');

    if not (deletar) then
     if ((trim(nomeAux) = '') and (geraNovo)) then
      destino := destino + '_JPG';


    jpg.SaveToFile(ChangeFileExt(destino,'.JPG'));
    verificador := true;
   except
    on E: Exception do
    begin
      ShowMessage('Erro: ' + E.Message);
    end;
   end;
   if ((verificador) and (deletar)) then
    DeleteFile(arquivo);


  finally
    FreeAndNil(png);
    FreeAndNil(jpg);
    FreeAndNil(bit);
    FreeAndNil(componente);
  end;



end;

constructor TConversor.create(LocalArquivos: TStringList; localDestino, nomeAux: string;
  formatoOrigem, formatoDestino: integer; aplicarFundo,  deletarArqOrigem,
  gerarNovoArquivo: Boolean; corFundo : TColor);
begin
   LocArquivos      := LocalArquivos;
   LocDestino       := localDestino;
   nomeAuxiliar     := nomeAux;
   fmtOrigem        := formatoOrigem;
   fmtDestino       := formatoDestino;
   fundo            := aplicarFundo;
   cor              := corFundo;
   deleteArqOrigem  := deletarArqOrigem;
   geraNovoArquivo  := gerarNovoArquivo;
end;


function TConversor.formatoValido(arquivo : string; formato: integer): Boolean;
var
 valido : boolean;
 extensao1, extensao2 : string;
begin
  valido := true;

  if (formato = 0) then // JPG OU JPEG
  begin
   extensao1 := '.JPG';
   extensao2 := '.JPEG';
  end
   else if (formato = 1) then // PNG
   begin
    extensao1 := '.PNG';
    extensao2 := '.PNG';
   end
    else if (formato = 2) then // BMP
    begin
      extensao1 := '.BPM';
      extensao2 := '.BMP';
    end;


  if (FileExists(arquivo)) then
  begin
   if not ((ExtractFileExt(UpperCase(arquivo)) = UpperCase(extensao1))
   or (ExtractFileExt(UpperCase(arquivo)) = UpperCase(extensao2)) ) then
    valido := false
  end
   else
    valido := true;

  result := valido;
end;

end.
