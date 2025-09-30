(herald "Basic DKIM Model"
  (bound 12)
)

(defprotocol seal-basic basic
  (defrole sender-dns-init
    (vars
      (auth_sender_dns chan)
      (any mesg)
      (keystore locn)
      (sender name)
      (info data)
      (sender_pub_k akey)
    )
    (trace
      (send auth_sender_dns (cat sender info sender_pub_k "DKIM DNS TXT RECORD"))
      (load keystore any)
      (stor keystore (invk sender_pub_k))
    )
    (uniq-orig sender_pub_k (invk sender_pub_k))
    (auth auth_sender_dns)
  )
  (defrole sender-sign-local
    (vars
      (keystore locn)
      (media data)
      (sender_pub_k akey)
    )
    (trace
      (load keystore (invk sender_pub_k))
      (send (cat media (enc (hash media) (invk sender_pub_k))))
    )
    (uniq-orig media)
    (gen-st (invk sender_pub_k))
  )
  (defrole dns-server
    (vars
      (auth_sender_dns auth_verifier_dns chan)
      (any mesg)
      (keystore locn)
      (sender name)
      (info data)
      (sender_pub_k akey)
    )
    (trace
      (recv auth_sender_dns (cat sender info sender_pub_k "DKIM DNS TXT RECORD"))
      (send auth_verifier_dns (cat "DNS RECORD" sender info sender_pub_k))
    )
    (auth auth_sender_dns)
  )
  (defrole verifier-local
    (vars
      (auth_verifier_dns chan)
      (media data)
      (sender name)
      (info data)
      (sender_pub_k akey)
    )
    (trace
      (recv auth_verifier_dns (cat "DNS RECORD" sender info sender_pub_k))
      (recv (cat media (enc (hash media) (invk sender_pub_k))))
    )
  )
)

(defskeleton seal-basic
  (vars
    (auth_sender_dns chan)
    (sender_pub_k akey)
  )
  (defstrandmax dns-server
    (sender_pub_k sender_pub_k)
    (auth_sender_dns auth_sender_dns))
  (auth auth_sender_dns)
)

(defskeleton seal-basic
  (vars
    (sender_pub_k akey)
    (auth_verifier_dns chan)
  )
  (defstrandmax verifier-local
    (sender_pub_k sender_pub_k)
    (auth_verifier_dns auth_verifier_dns))
  (uniq-orig sender_pub_k)
  (pen-non-orig (invk sender_pub_k))
  (auth auth_verifier_dns)
)
