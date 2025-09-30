(defprotocol HARPS basic
	   (defrole trustagent
		    (vars (ta i r name) (k2 k5 skey))
		    (trace
			(send (enc (cat (hash (hash k2)) (hash (hash (hash k5))))(ltk ta i)))
			(send (enc (cat (hash (hash (hash k2))) (hash (hash k5)))(ltk ta r))))

		    (non-orig (ltk ta i) (ltk ta r))
		    (uniq-gen k2 k5))
	   (defrole init 
		    (vars (ta i r name) (k2 k5 K Kp skey) (n1 n2 text))
		    (trace 
			(recv (enc (cat (hash (hash k2)) (hash (hash (hash k5))))(ltk ta i)))
			(send (cat (enc n1 (hash (cat (hash (hash (hash k2))) (hash (hash (hash k5))))))))
			(recv (enc n2 n1 (hash (cat (hash (hash (hash k2))) (hash (hash (hash k5)))))))))
	   (defrole resp
		    (vars (ta r i name) (k2 k5 K Kp S skey) (n1 n2 text))
		    (trace 
			(recv (enc (cat (hash (hash (hash k2))) (hash (hash k5)))(ltk ta r)))
			(recv (cat (enc n1 (hash (cat (hash (hash (hash k2))) (hash (hash (hash k5))))))))
			(send (enc n2 n1 (hash (cat (hash (hash (hash k2))) (hash (hash (hash k5))))))))))

(defskeleton HARPS
	    (vars (ta i r name) (n1 n2 n text) (K Kp S k2 k5 skey))
	    (defstrandmax resp (n2 n2) (ta ta) (r r))
	    (non-orig (ltk ta r))
	    (uniq-orig n2))

(defskeleton HARPS 
	    (vars (ta i r name) (n1 n2 n text) (K Kp S k2 k5 skey))
	    (defstrandmax init (n1 n1) (ta ta) (i i))
	    (non-orig (ltk ta i))
	    (uniq-orig n1))
