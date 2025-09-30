(herald "Needham - Schroeder Symmetric Key Protocol " ) 
(defprotocol nss basic
         (defrole alice
              (vars (a b s name) (n1 n2 text) (k skey))
              (trace
            (send (cat a b n1))
            (recv (enc (cat n1 k b (enc (cat k a) (ltk b s))) (ltk a s)))
            (send (enc (cat k a) (ltk b s)))
            (recv (enc n2 k))
            (send (enc (cat n2 "1") k)))
	     ;(uniq-gen n1)
              (non-orig (ltk a s) (ltk b s)))
         (defrole bob 
              (vars (b a s name) (n2 text) (k skey))
              (trace 
            (recv (enc (cat k a) (ltk b s)))
            (send (enc n2 k))
            (recv (enc (cat n2 "1") k)))
	     ;(uniq-gen n2)
              (non-orig (ltk a s) (ltk b s)))
         (defrole server 
              (vars (s a b name) (n1 text) (k skey))
              (trace 
            (recv (cat a b n1))
            (send (enc (cat n1 k b (enc (cat k a) (ltk b s))) (ltk a s))))
              (uniq-orig k)
              (non-orig (ltk a s) (ltk b s))))

(defskeleton nss 
         (vars (a b s name) (n1 n2 text) (k skey))
         (defstrandmax alice (a a) (b b) (s s) (n1 n1)))
(defskeleton nss
         (vars (a b s name) (n2 text) (k skey))
         (defstrandmax bob  (a a) (b b) (s s) (n2 n2)))
(defskeleton nss
         (vars (a b s name) (n1 text) (k skey))
         (defstrandmax server (a a) (b b)  (s s) (n1 n1)))
