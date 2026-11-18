; Prototipi di funzione per un facile accesso da tutto il progetto

; file WinMain.asm
WinMain 			proto :DWORD, :DWORD, :DWORD, :DWORD

; file RegisterWindowMainClass.asm
RegisterWindowMainClass 	proto

; file MainWndProc.asm
MainWndProc 			proto :DWORD, :DWORD, :DWORD, :DWORD

; file FrameBuffer.asm
CreateFrameBuffer		proto :DWORD, :DWORD, :DWORD
DestroyFrameBuffer		proto :DWORD
ClearBuffer			proto :DWORD, :DWORD
PutPixel			proto :DWORD, :DWORD, :DWORD, :DWORD 
ReadPixel           		proto :DWORD, :DWORD, :DWORD

; file Lines.asm
DrawLineDDA			proto :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD




; file TestDraw.asm
TestDraw            		proto :DWORD
TestLines			proto :DWORD