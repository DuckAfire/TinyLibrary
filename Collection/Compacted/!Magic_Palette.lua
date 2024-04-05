----------------------------------------------------------------------------------
-- MIT License

-- Copyright (c) 2024 DuckAfire

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
----------------------------------------------------------------------------------

-- [COMPACTED] Copy and paste the code in your cart [v: 1.1]

local DA={}
local TINY_LIBRARY_LICENSE="github.com/DuckAfire/TinyLibrary/blob/main/LICENSE"

do local _U,_L,_S,_T,Tn,_F,Po,Pk=string.upper,string.lower,string.sub,type,tonumber,math.floor,poke,peek DA.sortCode=function(C,O,l) local o,c,c=O or 0,{} if _T(c)=="string" then local t,f,I=c,l and _L or _U,{1,3,5} for i=#t+1,6 do t=t.."0" end for i=1,3 do c[i]=f(_S(t,I[i],I[i]+1)) end else c=C end for i=1,3 do if not c[i] then c[i]=0 end end if o==0 then return c[1],c[2],c[3] elseif o==1 then c=c elseif o==2 then c={red=c[1],green=c[2],blue=c[3]} elseif o==3 then if hex then c="#"..c[1]..c[2]..c[3] else c=c[1]..", "..c[2]..", "..c[3] end else error('[ Magic_Palette ] The parameter "O" is invalid, try values between 0-3. In function "pale.sortCode", argument #2.') end return c end DA.save=function(h) local v if h then v="" else v={} end for i=0,15 do if not h then v[i]={} end for j=0,2 do if h then v=v..string.format("%x",Pk(0x03FC0+i*3+j)) else v[i][j]=Pk(0x03FC0+i*3+j) end end end return v end DA.toDec=function(C,O) local d={} local c=_T(C)=="table" and C[1] or C c=_S(c,1,1)=="#" and _S(c,2) or c for i=0,2 do local l=i+1+(i*1) d[i+1]=Tn(_S(c,l,l+1),16) end return DA.sortCode(d,O) end DA.toHex=function(C,O,L) local h="" for i=1,3 do if C[i]<0 then C[i]=0 elseif C[i]>255 then C[i]=255 end h=h..string.format("%x",_F(C[i])) end return DA.sortCode(h,O,L) end DA.swap=function(C,id) local c=C if _S(C,1,4)=="000:" then c=_S(C,5) elseif _S(C,1,1)=="#" then c=_S(C,2) end local function R(v,p) local a=p or 0 for i=0,2 do local l=i+1+(i*1) local k=Tn(_S(c,l+a,l+1+a),16) Po(0x03fc0+v*3+i,k) end end if id=="palette" then for id=0,15 do R(id,6*id) end elseif id=="equal" then for id=0,15 do R(id) end else R(Tn(id)) end end DA.light=function(S,t) local s,q=S and _F(S) or 1,0 for i=0,15 do for j=0,2 do local c,m,M=Pk(0x03FC0+i*3+j),_T(t)=="table" and t[i][j] or 0,_T(t)=="table" and t[i][j] or 255 local v=(c+s>=m) and c+s or m if s>0 then v=(c+s<=M) and c+s or M end Po(0x03FC0+i*3+j,v) if v==m or v==M then q=q+1 end end end return q==48 end end

local pale=DA -- you can customize this reference or not use it.
DA=nil
