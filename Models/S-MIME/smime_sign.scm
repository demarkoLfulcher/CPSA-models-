(defprotocol mime basic
	    (defrole alice
		     (vars (a b name) (msg text) (k skey))
		     (trace (send (enc b (cat (enc msg a (enc (hash msg) (privk a)) k) (enc k (pubk b)))(privk a)))))
	    (defrole bob 
		     (vars (a b name) (msg text) (k skey))
		     (trace (recv (enc b (cat (enc msg a (enc (hash msg) (privk a)) k) (enc k (pubk b)))(privk a))))))
(defskeleton mime
	    (vars (a b name) (msg text) (k skey))
	    (defstrand alice 1 (a a) (b b) (msg msg) (k k))
	    (uniq-orig k)
	    (facts (neq a b))
	    (non-orig (privk a) (privk b)))
(defskeleton mime 
	    (vars (a b name) (msg text) (k skey))
	    (defstrand bob 1 (a a) (b b) (msg msg) (k k))
	    (facts (neq a b))
	    (non-orig (privk a) (privk b)))
