#!/usr/bin/runghc

import Control.Concurrent.MVar
import Control.Concurrent
import Network.Socket
import Network hiding(accept)
import IO

data Message = Message String String String String

s (Message from to key text) = "From: " ++ from ++ "\n" ++ "To: " ++ to ++ "\n" ++ "Text: " ++ ({-e-} text) ++ "\n"

main = do
	b <- newMVar []
	s <- (listenOn . PortNumber) 62034
	p b s

p b s = do
	(s', _) <- accept s
	h <- socketToHandle s' ReadWriteMode
	c <- hGetLine h
	forkIO (f c b h)
	p b s

f c b h
	| c == "get" = do
		x <- takeMVar b
		n <- hGetLine h
		k <- hGetLine h
		hPutStrLn h (unlines (take (length[x])(map s (filter (m n k) x))))
		putMVar b x >> hClose h

	| c == "post" = do
		x <- takeMVar b
		f <- hGetLine h
		t <- hGetLine h
		k <- hGetLine h
		text <- hGetLine h
		putMVar b ((Message f t k text) : x) >> hPutStrLn h "o_O" >> hClose h

	| c == "check" = do
		x <- takeMVar b
		l <- hGetLine h
		hPutStrLn h (unlines (map f (filter (\y -> (read l) == length x) x)))
		putMVar b x
		hClose h
	
	| True = do hClose h where f (Message a b c d) = c

m t k (Message _ t1 k1 _) = (==) t t1 && (==) (f k) (f k1) where f k = take (length[k]) k

e [x] = [x]
e [x,y] = [y,x]
e (x:y:xs) = [y] ++ (e xs) ++ [x]

d [x] = [x]
d [x,y] = [y,x]
-- d (x:xs) = [las
