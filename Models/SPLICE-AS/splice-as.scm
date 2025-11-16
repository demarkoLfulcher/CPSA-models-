(herald "SPLICE/AS")

;; S, C, AS    : principal
;; N1, N2, N3, : nonce
;; TS          : timestamp
;; L           : lifetime
;; pk, sk      : princip -> keypair

;; C  -> AS    : C, S, N1
;; AS -> C     : AS, {AS, C, N1, pk(S)}sk(AS)
;; C  -> S     : C, S, {C, T, L, {N2}pk(S)}sk(C)
;; S  -> AS    : S, C, N3
;; AS -> S     : AS, {AS, S, N3, pk(C)}sk(AS)
;; S  -> C     : S, C, {S, inc(N2)}pk(C)

(defprotocol splice-as basic
	     (defrole client
		      (vars (C S AS name) (N1 N2 N3 text) (TS L data))
		      (trace 
			(send (cat C S N1))
			(recv (cat AS (enc AS C N1 (pubk S) (privk AS))))
			(send (cat (cat C S) (enc C TS L (enc N2 (pubk S)) (privk C))))
			(recv (cat (cat S C) (enc S (cat N2 "1") (pubk C))))))
	     (defrole auth-server
		      (vars (AS S C  name) (N1 N2 N3 text) (TS L data))
		      (trace
			(recv (cat C S N1))
			(send (cat AS (enc AS C N1 (pubk S) (privk AS)))) 
			(recv (cat S C N3))
			(send (cat AS (enc AS S N3 (pubk C) (privk AS))))))
	     (defrole server
		      (vars (S C AS name) (N1 N2 N3 text) (TS L data))
		      (trace 
			(recv (cat (cat C S) (enc C TS L (enc N2 (pubk S)) (privk C))))
			(send (cat S C N3))
			(recv (cat AS (enc AS S N3 (pubk C) (privk AS))))
			(send (cat (cat S C) (enc S (cat N2 "1") (pubk C)))))))

(defskeleton splice-as 
	     (vars (C S AS name) (N1 N2 N3 text) (TS L data))
	     (defstrandmax client (C C) (S S) (AS AS) (N1 N1) (TS TS) (L L))
	     (defstrandmax server (S S) (C C) (AS AS) (N2 N2))
	     (defstrandmax auth-server (AS AS) (S S) (C C) (N3 N3))
	     (uniq-orig N1 N2 N3 (pubk S) (pubk C))
	     (non-orig (privk S) (privk AS) (privk C)))
