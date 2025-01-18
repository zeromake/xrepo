local case_sensitive = true
local params = {
    ["PROV_PARAM_CORE_VERSION"] =         "openssl-version",
    ["PROV_PARAM_CORE_PROV_NAME"] =       "provider-name",
    ["PROV_PARAM_CORE_MODULE_FILENAME"] = "module-filename",

    ["PROV_PARAM_NAME"] =               "name",
    ["PROV_PARAM_VERSION"] =            "version",
    ["PROV_PARAM_BUILDINFO"] =          "buildinfo",
    ["PROV_PARAM_STATUS"] =             "status",
    ["PROV_PARAM_SECURITY_CHECKS"] =    "security-checks",
    ["PROV_PARAM_TLS1_PRF_EMS_CHECK"] = "tls1-prf-ems-check",
    ["PROV_PARAM_DRBG_TRUNC_DIGEST"] =  "drbg-no-trunc-md",

    ["PROV_PARAM_SELF_TEST_PHASE"] =  "st-phase",
    ["PROV_PARAM_SELF_TEST_TYPE"] =   "st-type",
    ["PROV_PARAM_SELF_TEST_DESC"] =   "st-desc",

    ["OBJECT_PARAM_TYPE"] =              "type",
    ["OBJECT_PARAM_DATA_TYPE"] =         "data-type",
    ["OBJECT_PARAM_DATA_STRUCTURE"] =    "data-structure",
    ["OBJECT_PARAM_REFERENCE"] =         "reference",
    ["OBJECT_PARAM_DATA"] =              "data",
    ["OBJECT_PARAM_DESC"] =              "desc",

    ["ALG_PARAM_DIGEST"] =       "digest",
    ["ALG_PARAM_CIPHER"] =       "cipher",
    ["ALG_PARAM_ENGINE"] =       "engine",
    ["ALG_PARAM_MAC"] =          "mac",
    ["ALG_PARAM_PROPERTIES"] =   "properties",

    ["CIPHER_PARAM_PADDING"] =              "padding",
    ["CIPHER_PARAM_USE_BITS"] =             "use-bits",
    ["CIPHER_PARAM_TLS_VERSION"] =          "tls-version",
    ["CIPHER_PARAM_TLS_MAC"] =              "tls-mac",
    ["CIPHER_PARAM_TLS_MAC_SIZE"] =         "tls-mac-size",
    ["CIPHER_PARAM_MODE"] =                 "mode",
    ["CIPHER_PARAM_BLOCK_SIZE"] =           "blocksize",
    ["CIPHER_PARAM_AEAD"] =                 "aead",
    ["CIPHER_PARAM_CUSTOM_IV"] =            "custom-iv",
    ["CIPHER_PARAM_CTS"] =                  "cts",
    ["CIPHER_PARAM_TLS1_MULTIBLOCK"] =      "tls-multi",
    ["CIPHER_PARAM_HAS_RAND_KEY"] =         "has-randkey",
    ["CIPHER_PARAM_KEYLEN"] =               "keylen",
    ["CIPHER_PARAM_IVLEN"] =                "ivlen",
    ["CIPHER_PARAM_IV"] =                   "iv",
    ["CIPHER_PARAM_UPDATED_IV"] =           "updated-iv",
    ["CIPHER_PARAM_NUM"] =                  "num",
    ["CIPHER_PARAM_ROUNDS"] =               "rounds",
    ["CIPHER_PARAM_AEAD_TAG"] =             "tag",
    ["CIPHER_PARAM_AEAD_TLS1_AAD"] =        "tlsaad",
    ["CIPHER_PARAM_AEAD_TLS1_AAD_PAD"] =    "tlsaadpad",
    ["CIPHER_PARAM_AEAD_TLS1_IV_FIXED"] =   "tlsivfixed",
    ["CIPHER_PARAM_AEAD_TLS1_GET_IV_GEN"] = "tlsivgen",
    ["CIPHER_PARAM_AEAD_TLS1_SET_IV_INV"] = "tlsivinv",
    ["CIPHER_PARAM_AEAD_IVLEN"] =           '*CIPHER_PARAM_IVLEN',
    ["CIPHER_PARAM_AEAD_TAGLEN"] =          "taglen",
    ["CIPHER_PARAM_AEAD_MAC_KEY"] =         "mackey",
    ["CIPHER_PARAM_RANDOM_KEY"] =           "randkey",
    ["CIPHER_PARAM_RC2_KEYBITS"] =          "keybits",
    ["CIPHER_PARAM_SPEED"] =                "speed",
    ["CIPHER_PARAM_CTS_MODE"] =             "cts_mode",

    ["CIPHER_PARAM_ALGORITHM_ID_PARAMS"] =  "alg_id_param",
    ["CIPHER_PARAM_XTS_STANDARD"] =         "xts_standard",

    ["CIPHER_PARAM_TLS1_MULTIBLOCK_MAX_SEND_FRAGMENT"] =  "tls1multi_maxsndfrag",
    ["CIPHER_PARAM_TLS1_MULTIBLOCK_MAX_BUFSIZE"] =        "tls1multi_maxbufsz",
    ["CIPHER_PARAM_TLS1_MULTIBLOCK_INTERLEAVE"] =         "tls1multi_interleave",
    ["CIPHER_PARAM_TLS1_MULTIBLOCK_AAD"] =                "tls1multi_aad",
    ["CIPHER_PARAM_TLS1_MULTIBLOCK_AAD_PACKLEN"] =        "tls1multi_aadpacklen",
    ["CIPHER_PARAM_TLS1_MULTIBLOCK_ENC"] =                "tls1multi_enc",
    ["CIPHER_PARAM_TLS1_MULTIBLOCK_ENC_IN"] =             "tls1multi_encin",
    ["CIPHER_PARAM_TLS1_MULTIBLOCK_ENC_LEN"] =            "tls1multi_enclen",

    ["DIGEST_PARAM_XOFLEN"] =       "xoflen",
    ["DIGEST_PARAM_SSL3_MS"] =      "ssl3-ms",
    ["DIGEST_PARAM_PAD_TYPE"] =     "pad-type",
    ["DIGEST_PARAM_MICALG"] =       "micalg",
    ["DIGEST_PARAM_BLOCK_SIZE"] =   "blocksize",
    ["DIGEST_PARAM_SIZE"] =         "size",
    ["DIGEST_PARAM_XOF"] =          "xof",
    ["DIGEST_PARAM_ALGID_ABSENT"] = "algid-absent",

    ["MAC_PARAM_KEY"] =            "key",
    ["MAC_PARAM_IV"] =             "iv",
    ["MAC_PARAM_CUSTOM"] =         "custom",
    ["MAC_PARAM_SALT"] =           "salt",
    ["MAC_PARAM_XOF"] =            "xof",
    ["MAC_PARAM_DIGEST_NOINIT"] =  "digest-noinit",
    ["MAC_PARAM_DIGEST_ONESHOT"] = "digest-oneshot",
    ["MAC_PARAM_C_ROUNDS"] =       "c-rounds",
    ["MAC_PARAM_D_ROUNDS"] =       "d-rounds",

    ["MAC_PARAM_CIPHER"] =           '*ALG_PARAM_CIPHER',
    ["MAC_PARAM_DIGEST"] =           '*ALG_PARAM_DIGEST',
    ["MAC_PARAM_PROPERTIES"] =       '*ALG_PARAM_PROPERTIES',
    ["MAC_PARAM_SIZE"] =             "size",
    ["MAC_PARAM_BLOCK_SIZE"] =       "block-size",
    ["MAC_PARAM_TLS_DATA_SIZE"] =    "tls-data-size",

    ["KDF_PARAM_SECRET"] =       "secret",
    ["KDF_PARAM_KEY"] =          "key",
    ["KDF_PARAM_SALT"] =         "salt",
    ["KDF_PARAM_PASSWORD"] =     "pass",
    ["KDF_PARAM_PREFIX"] =       "prefix",
    ["KDF_PARAM_LABEL"] =        "label",
    ["KDF_PARAM_DATA"] =         "data",
    ["KDF_PARAM_DIGEST"] =       '*ALG_PARAM_DIGEST',
    ["KDF_PARAM_CIPHER"] =       '*ALG_PARAM_CIPHER',
    ["KDF_PARAM_MAC"] =          '*ALG_PARAM_MAC',
    ["KDF_PARAM_MAC_SIZE"] =     "maclen",
    ["KDF_PARAM_PROPERTIES"] =   '*ALG_PARAM_PROPERTIES',
    ["KDF_PARAM_ITER"] =         "iter",
    ["KDF_PARAM_MODE"] =         "mode",
    ["KDF_PARAM_PKCS5"] =        "pkcs5",
    ["KDF_PARAM_UKM"] =          "ukm",
    ["KDF_PARAM_CEK_ALG"] =      "cekalg",
    ["KDF_PARAM_SCRYPT_N"] =     "n",
    ["KDF_PARAM_SCRYPT_R"] =     "r",
    ["KDF_PARAM_SCRYPT_P"] =     "p",
    ["KDF_PARAM_SCRYPT_MAXMEM"] = "maxmem_bytes",
    ["KDF_PARAM_INFO"] =         "info",
    ["KDF_PARAM_SEED"] =         "seed",
    ["KDF_PARAM_SSHKDF_XCGHASH"] = "xcghash",
    ["KDF_PARAM_SSHKDF_SESSION_ID"] = "session_id",
    ["KDF_PARAM_SSHKDF_TYPE"] =  "type",
    ["KDF_PARAM_SIZE"] =         "size",
    ["KDF_PARAM_CONSTANT"] =     "constant",
    ["KDF_PARAM_PKCS12_ID"] =    "id",
    ["KDF_PARAM_KBKDF_USE_L"] =          "use-l",
    ["KDF_PARAM_KBKDF_USE_SEPARATOR"] =  "use-separator",
    ["KDF_PARAM_KBKDF_R"] =      "r",
    ["KDF_PARAM_X942_ACVPINFO"] =        "acvp-info",
    ["KDF_PARAM_X942_PARTYUINFO"] =      "partyu-info",
    ["KDF_PARAM_X942_PARTYVINFO"] =      "partyv-info",
    ["KDF_PARAM_X942_SUPP_PUBINFO"] =    "supp-pubinfo",
    ["KDF_PARAM_X942_SUPP_PRIVINFO"] =   "supp-privinfo",
    ["KDF_PARAM_X942_USE_KEYBITS"] =     "use-keybits",
    ["KDF_PARAM_HMACDRBG_ENTROPY"] =     "entropy",
    ["KDF_PARAM_HMACDRBG_NONCE"] =       "nonce",
    ["KDF_PARAM_THREADS"] =        "threads",
    ["KDF_PARAM_EARLY_CLEAN"] =    "early_clean",
    ["KDF_PARAM_ARGON2_AD"] =      "ad",
    ["KDF_PARAM_ARGON2_LANES"] =   "lanes",
    ["KDF_PARAM_ARGON2_MEMCOST"] = "memcost",
    ["KDF_PARAM_ARGON2_VERSION"] = "version",

    ["RAND_PARAM_STATE"] =                   "state",
    ["RAND_PARAM_STRENGTH"] =                "strength",
    ["RAND_PARAM_MAX_REQUEST"] =             "max_request",
    ["RAND_PARAM_TEST_ENTROPY"] =            "test_entropy",
    ["RAND_PARAM_TEST_NONCE"] =              "test_nonce",
    ["RAND_PARAM_GENERATE"] =                "generate",

    ["DRBG_PARAM_RESEED_REQUESTS"] =         "reseed_requests",
    ["DRBG_PARAM_RESEED_TIME_INTERVAL"] =    "reseed_time_interval",
    ["DRBG_PARAM_MIN_ENTROPYLEN"] =          "min_entropylen",
    ["DRBG_PARAM_MAX_ENTROPYLEN"] =          "max_entropylen",
    ["DRBG_PARAM_MIN_NONCELEN"] =            "min_noncelen",
    ["DRBG_PARAM_MAX_NONCELEN"] =            "max_noncelen",
    ["DRBG_PARAM_MAX_PERSLEN"] =             "max_perslen",
    ["DRBG_PARAM_MAX_ADINLEN"] =             "max_adinlen",
    ["DRBG_PARAM_RESEED_COUNTER"] =          "reseed_counter",
    ["DRBG_PARAM_RESEED_TIME"] =             "reseed_time",
    ["DRBG_PARAM_PROPERTIES"] =              '*ALG_PARAM_PROPERTIES',
    ["DRBG_PARAM_DIGEST"] =                  '*ALG_PARAM_DIGEST',
    ["DRBG_PARAM_CIPHER"] =                  '*ALG_PARAM_CIPHER',
    ["DRBG_PARAM_MAC"] =                     '*ALG_PARAM_MAC',
    ["DRBG_PARAM_USE_DF"] =                  "use_derivation_function",

    ["DRBG_PARAM_ENTROPY_REQUIRED"] =        "entropy_required",
    ["DRBG_PARAM_PREDICTION_RESISTANCE"] =   "prediction_resistance",
    ["DRBG_PARAM_MIN_LENGTH"] =              "minium_length",
    ["DRBG_PARAM_MAX_LENGTH"] =              "maxium_length",
    ["DRBG_PARAM_RANDOM_DATA"] =             "random_data",
    ["DRBG_PARAM_SIZE"] =                    "size",

    ["PKEY_PARAM_BITS"] =                "bits",
    ["PKEY_PARAM_MAX_SIZE"] =            "max-size",
    ["PKEY_PARAM_SECURITY_BITS"] =       "security-bits",
    ["PKEY_PARAM_DIGEST"] =              '*ALG_PARAM_DIGEST',
    ["PKEY_PARAM_CIPHER"] =              '*ALG_PARAM_CIPHER',
    ["PKEY_PARAM_ENGINE"] =              '*ALG_PARAM_ENGINE',
    ["PKEY_PARAM_PROPERTIES"] =          '*ALG_PARAM_PROPERTIES',
    ["PKEY_PARAM_DEFAULT_DIGEST"] =      "default-digest",
    ["PKEY_PARAM_MANDATORY_DIGEST"] =    "mandatory-digest",
    ["PKEY_PARAM_PAD_MODE"] =            "pad-mode",
    ["PKEY_PARAM_DIGEST_SIZE"] =         "digest-size",
    ["PKEY_PARAM_MASKGENFUNC"] =         "mgf",
    ["PKEY_PARAM_MGF1_DIGEST"] =         "mgf1-digest",
    ["PKEY_PARAM_MGF1_PROPERTIES"] =     "mgf1-properties",
    ["PKEY_PARAM_ENCODED_PUBLIC_KEY"] =  "encoded-pub-key",
    ["PKEY_PARAM_GROUP_NAME"] =          "group",
    ["PKEY_PARAM_DIST_ID"] =             "distid",
    ["PKEY_PARAM_PUB_KEY"] =             "pub",
    ["PKEY_PARAM_PRIV_KEY"] =            "priv",
    ["PKEY_PARAM_IMPLICIT_REJECTION"] =  "implicit-rejection",

    ["PKEY_PARAM_FFC_P"] =               "p",
    ["PKEY_PARAM_FFC_G"] =               "g",
    ["PKEY_PARAM_FFC_Q"] =               "q",
    ["PKEY_PARAM_FFC_GINDEX"] =          "gindex",
    ["PKEY_PARAM_FFC_PCOUNTER"] =        "pcounter",
    ["PKEY_PARAM_FFC_SEED"] =            "seed",
    ["PKEY_PARAM_FFC_COFACTOR"] =        "j",
    ["PKEY_PARAM_FFC_H"] =               "hindex",
    ["PKEY_PARAM_FFC_VALIDATE_PQ"] =     "validate-pq",
    ["PKEY_PARAM_FFC_VALIDATE_G"] =      "validate-g",
    ["PKEY_PARAM_FFC_VALIDATE_LEGACY"] = "validate-legacy",

    ["PKEY_PARAM_DH_GENERATOR"] =        "safeprime-generator",
    ["PKEY_PARAM_DH_PRIV_LEN"] =         "priv_len",

    ["PKEY_PARAM_EC_PUB_X"] =     "qx",
    ["PKEY_PARAM_EC_PUB_Y"] =     "qy",

    ["PKEY_PARAM_EC_FIELD_TYPE"] =                   "field-type",
    ["PKEY_PARAM_EC_P"] =                            "p",
    ["PKEY_PARAM_EC_A"] =                            "a",
    ["PKEY_PARAM_EC_B"] =                            "b",
    ["PKEY_PARAM_EC_GENERATOR"] =                    "generator",
    ["PKEY_PARAM_EC_ORDER"] =                        "order",
    ["PKEY_PARAM_EC_COFACTOR"] =                     "cofactor",
    ["PKEY_PARAM_EC_SEED"] =                         "seed",
    ["PKEY_PARAM_EC_CHAR2_M"] =                      "m",
    ["PKEY_PARAM_EC_CHAR2_TYPE"] =                   "basis-type",
    ["PKEY_PARAM_EC_CHAR2_TP_BASIS"] =               "tp",
    ["PKEY_PARAM_EC_CHAR2_PP_K1"] =                  "k1",
    ["PKEY_PARAM_EC_CHAR2_PP_K2"] =                  "k2",
    ["PKEY_PARAM_EC_CHAR2_PP_K3"] =                  "k3",
    ["PKEY_PARAM_EC_DECODED_FROM_EXPLICIT_PARAMS"] = "decoded-from-explicit",

    ["PKEY_PARAM_USE_COFACTOR_FLAG"] = "use-cofactor-flag",
    ["PKEY_PARAM_USE_COFACTOR_ECDH"] = '*PKEY_PARAM_USE_COFACTOR_FLAG',

    ["PKEY_PARAM_RSA_N"] =           "n",
    ["PKEY_PARAM_RSA_E"] =           "e",
    ["PKEY_PARAM_RSA_D"] =           "d",
    ["PKEY_PARAM_RSA_FACTOR"] =      "rsa-factor",
    ["PKEY_PARAM_RSA_EXPONENT"] =    "rsa-exponent",
    ["PKEY_PARAM_RSA_COEFFICIENT"] = "rsa-coefficient",
    ["PKEY_PARAM_RSA_FACTOR1"] =      "rsa-factor1",
    ["PKEY_PARAM_RSA_FACTOR2"] =      "rsa-factor2",
    ["PKEY_PARAM_RSA_FACTOR3"] =      "rsa-factor3",
    ["PKEY_PARAM_RSA_FACTOR4"] =      "rsa-factor4",
    ["PKEY_PARAM_RSA_FACTOR5"] =      "rsa-factor5",
    ["PKEY_PARAM_RSA_FACTOR6"] =      "rsa-factor6",
    ["PKEY_PARAM_RSA_FACTOR7"] =      "rsa-factor7",
    ["PKEY_PARAM_RSA_FACTOR8"] =      "rsa-factor8",
    ["PKEY_PARAM_RSA_FACTOR9"] =      "rsa-factor9",
    ["PKEY_PARAM_RSA_FACTOR10"] =     "rsa-factor10",
    ["PKEY_PARAM_RSA_EXPONENT1"] =    "rsa-exponent1",
    ["PKEY_PARAM_RSA_EXPONENT2"] =    "rsa-exponent2",
    ["PKEY_PARAM_RSA_EXPONENT3"] =    "rsa-exponent3",
    ["PKEY_PARAM_RSA_EXPONENT4"] =    "rsa-exponent4",
    ["PKEY_PARAM_RSA_EXPONENT5"] =    "rsa-exponent5",
    ["PKEY_PARAM_RSA_EXPONENT6"] =    "rsa-exponent6",
    ["PKEY_PARAM_RSA_EXPONENT7"] =    "rsa-exponent7",
    ["PKEY_PARAM_RSA_EXPONENT8"] =    "rsa-exponent8",
    ["PKEY_PARAM_RSA_EXPONENT9"] =    "rsa-exponent9",
    ["PKEY_PARAM_RSA_EXPONENT10"] =   "rsa-exponent10",
    ["PKEY_PARAM_RSA_COEFFICIENT1"] = "rsa-coefficient1",
    ["PKEY_PARAM_RSA_COEFFICIENT2"] = "rsa-coefficient2",
    ["PKEY_PARAM_RSA_COEFFICIENT3"] = "rsa-coefficient3",
    ["PKEY_PARAM_RSA_COEFFICIENT4"] = "rsa-coefficient4",
    ["PKEY_PARAM_RSA_COEFFICIENT5"] = "rsa-coefficient5",
    ["PKEY_PARAM_RSA_COEFFICIENT6"] = "rsa-coefficient6",
    ["PKEY_PARAM_RSA_COEFFICIENT7"] = "rsa-coefficient7",
    ["PKEY_PARAM_RSA_COEFFICIENT8"] = "rsa-coefficient8",
    ["PKEY_PARAM_RSA_COEFFICIENT9"] = "rsa-coefficient9",

    ["PKEY_PARAM_RSA_BITS"] =             '*PKEY_PARAM_BITS',
    ["PKEY_PARAM_RSA_PRIMES"] =           "primes",
    ["PKEY_PARAM_RSA_DIGEST"] =           '*PKEY_PARAM_DIGEST',
    ["PKEY_PARAM_RSA_DIGEST_PROPS"] =     '*PKEY_PARAM_PROPERTIES',
    ["PKEY_PARAM_RSA_MASKGENFUNC"] =      '*PKEY_PARAM_MASKGENFUNC',
    ["PKEY_PARAM_RSA_MGF1_DIGEST"] =      '*PKEY_PARAM_MGF1_DIGEST',
    ["PKEY_PARAM_RSA_PSS_SALTLEN"] =      "saltlen",
    ["PKEY_PARAM_RSA_DERIVE_FROM_PQ"]    =     "rsa-derive-from-pq",

    ["PKEY_PARAM_DHKEM_IKM"] =        "dhkem-ikm",

    ["PKEY_PARAM_FFC_TYPE"] =         "type",
    ["PKEY_PARAM_FFC_PBITS"] =        "pbits",
    ["PKEY_PARAM_FFC_QBITS"] =        "qbits",
    ["PKEY_PARAM_FFC_DIGEST"] =       '*PKEY_PARAM_DIGEST',
    ["PKEY_PARAM_FFC_DIGEST_PROPS"] = '*PKEY_PARAM_PROPERTIES',

    ["PKEY_PARAM_EC_ENCODING"] =                "encoding",
    ["PKEY_PARAM_EC_POINT_CONVERSION_FORMAT"] = "point-format",
    ["PKEY_PARAM_EC_GROUP_CHECK_TYPE"] =        "group-check",
    ["PKEY_PARAM_EC_INCLUDE_PUBLIC"] =          "include-public",

    ["EXCHANGE_PARAM_PAD"] =                   "pad",
    ["EXCHANGE_PARAM_EC_ECDH_COFACTOR_MODE"] = "ecdh-cofactor-mode",
    ["EXCHANGE_PARAM_KDF_TYPE"] =              "kdf-type",
    ["EXCHANGE_PARAM_KDF_DIGEST"] =            "kdf-digest",
    ["EXCHANGE_PARAM_KDF_DIGEST_PROPS"] =      "kdf-digest-props",
    ["EXCHANGE_PARAM_KDF_OUTLEN"] =            "kdf-outlen",

    ["EXCHANGE_PARAM_KDF_UKM"] =               "kdf-ukm",

    ["SIGNATURE_PARAM_ALGORITHM_ID"] =       "algorithm-id",
    ["SIGNATURE_PARAM_PAD_MODE"] =           '*PKEY_PARAM_PAD_MODE',
    ["SIGNATURE_PARAM_DIGEST"] =             '*PKEY_PARAM_DIGEST',
    ["SIGNATURE_PARAM_PROPERTIES"] =         '*PKEY_PARAM_PROPERTIES',
    ["SIGNATURE_PARAM_PSS_SALTLEN"] =        "saltlen",
    ["SIGNATURE_PARAM_MGF1_DIGEST"] =        '*PKEY_PARAM_MGF1_DIGEST',
    ["SIGNATURE_PARAM_MGF1_PROPERTIES"] =    '*PKEY_PARAM_MGF1_PROPERTIES',
    ["SIGNATURE_PARAM_DIGEST_SIZE"] =        '*PKEY_PARAM_DIGEST_SIZE',
    ["SIGNATURE_PARAM_NONCE_TYPE"] =         "nonce-type",
    ["SIGNATURE_PARAM_INSTANCE"] =           "instance",
    ["SIGNATURE_PARAM_CONTEXT_STRING"] =     "context-string",

    ["ASYM_CIPHER_PARAM_DIGEST"] =                   '*PKEY_PARAM_DIGEST',
    ["ASYM_CIPHER_PARAM_PROPERTIES"] =               '*PKEY_PARAM_PROPERTIES',
    ["ASYM_CIPHER_PARAM_ENGINE"] =                   '*PKEY_PARAM_ENGINE',
    ["ASYM_CIPHER_PARAM_PAD_MODE"] =                 '*PKEY_PARAM_PAD_MODE',
    ["ASYM_CIPHER_PARAM_MGF1_DIGEST"] =              '*PKEY_PARAM_MGF1_DIGEST',
    ["ASYM_CIPHER_PARAM_MGF1_DIGEST_PROPS"] =        '*PKEY_PARAM_MGF1_PROPERTIES',
    ["ASYM_CIPHER_PARAM_OAEP_DIGEST"] =              '*ALG_PARAM_DIGEST',
    ["ASYM_CIPHER_PARAM_OAEP_DIGEST_PROPS"] =        "digest-props",

    ["ASYM_CIPHER_PARAM_OAEP_LABEL"] =               "oaep-label",
    ["ASYM_CIPHER_PARAM_TLS_CLIENT_VERSION"] =       "tls-client-version",
    ["ASYM_CIPHER_PARAM_TLS_NEGOTIATED_VERSION"] =   "tls-negotiated-version",
    ["ASYM_CIPHER_PARAM_IMPLICIT_REJECTION"] =       "implicit-rejection",

    ["ENCODER_PARAM_CIPHER"] =           '*ALG_PARAM_CIPHER',
    ["ENCODER_PARAM_PROPERTIES"] =       '*ALG_PARAM_PROPERTIES',

    ["ENCODER_PARAM_ENCRYPT_LEVEL"] =    "encrypt-level",
    ["ENCODER_PARAM_SAVE_PARAMETERS"] =  "save-parameters",

    ["DECODER_PARAM_PROPERTIES"] =       '*ALG_PARAM_PROPERTIES',

    ["PASSPHRASE_PARAM_INFO"] =          "info",

    ["GEN_PARAM_POTENTIAL"] =            "potential",
    ["GEN_PARAM_ITERATION"] =            "iteration",

    ["PKEY_PARAM_RSA_TEST_XP1"] = "xp1",
    ["PKEY_PARAM_RSA_TEST_XP2"] = "xp2",
    ["PKEY_PARAM_RSA_TEST_XP"] =  "xp",
    ["PKEY_PARAM_RSA_TEST_XQ1"] = "xq1",
    ["PKEY_PARAM_RSA_TEST_XQ2"] = "xq2",
    ["PKEY_PARAM_RSA_TEST_XQ"] =  "xq",
    ["PKEY_PARAM_RSA_TEST_P1"] =  "p1",
    ["PKEY_PARAM_RSA_TEST_P2"] =  "p2",
    ["PKEY_PARAM_RSA_TEST_Q1"] =  "q1",
    ["PKEY_PARAM_RSA_TEST_Q2"] =  "q2",
    ["SIGNATURE_PARAM_KAT"] =     "kat",

    ["KEM_PARAM_OPERATION"] =            "operation",
    ["KEM_PARAM_IKME"] =                 "ikme",

    ["CAPABILITY_TLS_GROUP_NAME"] =              "tls-group-name",
    ["CAPABILITY_TLS_GROUP_NAME_INTERNAL"] =     "tls-group-name-internal",
    ["CAPABILITY_TLS_GROUP_ID"] =                "tls-group-id",
    ["CAPABILITY_TLS_GROUP_ALG"] =               "tls-group-alg",
    ["CAPABILITY_TLS_GROUP_SECURITY_BITS"] =     "tls-group-sec-bits",
    ["CAPABILITY_TLS_GROUP_IS_KEM"] =            "tls-group-is-kem",
    ["CAPABILITY_TLS_GROUP_MIN_TLS"] =           "tls-min-tls",
    ["CAPABILITY_TLS_GROUP_MAX_TLS"] =           "tls-max-tls",
    ["CAPABILITY_TLS_GROUP_MIN_DTLS"] =          "tls-min-dtls",
    ["CAPABILITY_TLS_GROUP_MAX_DTLS"] =          "tls-max-dtls",

    ["CAPABILITY_TLS_SIGALG_IANA_NAME"] =         "tls-sigalg-iana-name",
    ["CAPABILITY_TLS_SIGALG_CODE_POINT"] =        "tls-sigalg-code-point",
    ["CAPABILITY_TLS_SIGALG_NAME"] =              "tls-sigalg-name",
    ["CAPABILITY_TLS_SIGALG_OID"] =               "tls-sigalg-oid",
    ["CAPABILITY_TLS_SIGALG_SIG_NAME"] =          "tls-sigalg-sig-name",
    ["CAPABILITY_TLS_SIGALG_SIG_OID"] =           "tls-sigalg-sig-oid",
    ["CAPABILITY_TLS_SIGALG_HASH_NAME"] =         "tls-sigalg-hash-name",
    ["CAPABILITY_TLS_SIGALG_HASH_OID"] =          "tls-sigalg-hash-oid",
    ["CAPABILITY_TLS_SIGALG_KEYTYPE"] =           "tls-sigalg-keytype",
    ["CAPABILITY_TLS_SIGALG_KEYTYPE_OID"] =       "tls-sigalg-keytype-oid",
    ["CAPABILITY_TLS_SIGALG_SECURITY_BITS"] =     "tls-sigalg-sec-bits",
    ["CAPABILITY_TLS_SIGALG_MIN_TLS"] =           "tls-min-tls",
    ["CAPABILITY_TLS_SIGALG_MAX_TLS"] =           "tls-max-tls",

    ["STORE_PARAM_EXPECT"] =     "expect",
    ["STORE_PARAM_SUBJECT"] =    "subject",
    ["STORE_PARAM_ISSUER"] =     "name",
    ["STORE_PARAM_SERIAL"] =     "serial",
    ["STORE_PARAM_DIGEST"] =     "digest",
    ["STORE_PARAM_FINGERPRINT"] = "fingerprint",
    ["STORE_PARAM_ALIAS"] =      "alias",

    ["STORE_PARAM_PROPERTIES"] = "properties",

    ["STORE_PARAM_INPUT_TYPE"] = "input-type",

    ["LIBSSL_RECORD_LAYER_PARAM_OPTIONS"] =        "options",
    ["LIBSSL_RECORD_LAYER_PARAM_MODE"] =           "mode",
    ["LIBSSL_RECORD_LAYER_PARAM_READ_AHEAD"] =     "read_ahead",
    ["LIBSSL_RECORD_LAYER_READ_BUFFER_LEN"] =      "read_buffer_len",
    ["LIBSSL_RECORD_LAYER_PARAM_USE_ETM"] =        "use_etm",
    ["LIBSSL_RECORD_LAYER_PARAM_STREAM_MAC"] =     "stream_mac",
    ["LIBSSL_RECORD_LAYER_PARAM_TLSTREE"] =        "tlstree",
    ["LIBSSL_RECORD_LAYER_PARAM_MAX_FRAG_LEN"] =   "max_frag_len",
    ["LIBSSL_RECORD_LAYER_PARAM_MAX_EARLY_DATA"] = "max_early_data",
    ["LIBSSL_RECORD_LAYER_PARAM_BLOCK_PADDING"] =  "block_padding",
}

function table.keys(t)
    local keys = {}
    for k, _ in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

local params_keys = table.keys(params)
table.sort(params_keys)


function generate_public_macros()
    local macros = {}
    for _, name in ipairs(params_keys) do
        local val = params[name]
        local def = '# define OSSL_' .. name .. ' '
        if val:startswith('*') then
            def = def .. 'OSSL_' .. val:sub(2)
        else
            def = def .. '"' .. val .. '"'
        end
        table.insert(macros, def)
    end
    table.sort(macros)
    return table.concat(macros, '\n')
end

function generate_internal_macros()
    local macros = {}
    local count = 0
    local reverse = {}
    for _, name in ipairs(params_keys) do
        local val = params[name]
        if not val:startswith('*') and reverse[val] == nil then
            reverse[val] = count
            count = count + 1
        end
    end
    for _, name in ipairs(params_keys) do
        local val = params[name]
        local def = '#define PIDX_' .. name .. ' '
        if val:startswith('*') then
            def = def .. 'PIDX_' .. val:sub(2)
        else
            def = def .. reverse[val]
        end
        table.insert(macros, def)
    end
    table.sort(macros)
    return '#define NUM_PIDX ' .. count .. '\n\n' .. table.concat(macros, '\n')
end

function generate_trie()
    local trie = {}
    local nodes = 0
    local chars = 0
    for _, name in ipairs(params_keys) do
        local val = params[name]
        if not val:startswith('*') then
            local cursor = trie
            chars = chars + #val
            for i = 1, #val do
                local c = val:sub(i, i)
                if not case_sensitive then
                    if c == '-' then c = '_' end
                    c = c:lower()
                end
                if cursor[c] == nil then
                    cursor[c] = {}
                    nodes = nodes + 1
                end
                cursor = cursor[c]
            end
            cursor['val'] = name
        end
    end
    return trie
end

local function repeat_string(str, n)
    local result = ""
    for i = 1, n do
        result = result .. str
    end
    return result
end

function generate_code_from_trie(f, n, trieref)
    local idt = "    "
    local indent0 = repeat_string(idt, n + 1)
    local indent1 = indent0 .. idt
    local strcmp = case_sensitive and "strcmp" or "strcasecmp"
    -- if trieref == nil then
    --     return
    -- end
    if n == 0 then
        f:writef('int ossl_param_find_pidx(const char *s)\n{\n')
    end
    if trieref['suffix'] ~= nil then
        local suf = trieref['suffix']
        f:writef('%sif (%s("%s", s + %d) == 0', indent0, strcmp, suf, n)
        if not case_sensitive then
            suf = suf:gsub("-", "_")
            if suf ~= trieref['suffix'] then
                f:writef(' || %s("%s", s + %d) == 0)')
            end
        end
        f:writef(')\n%sreturn PIDX_%s;\n', indent1, trieref['name'])
        return
    end
    f:writef('%sswitch(s[%d]) {\n', indent0, n)
    f:writef('%sdefault:\n', indent0)
    local keys = table.keys(trieref)
    table.sort(keys)
    for _, l in ipairs(keys) do
        if l == 'val' then
            f:writef('%sbreak;\n', indent1)
            f:writef('%scase \'\\0\':\n', indent0)
            f:writef('%sreturn PIDX_%s;\n', indent1, trieref['val'])
        else
            f:writef('%sbreak;\n', indent1)
            f:writef('%scase \'%s\':', indent0, l)
            if not case_sensitive then
                if l == '-' then
                    f:writef('   case \'-\':')
                end
                local lu = l:upper()
                if l ~= lu then
                    f:writef('   case \'%s\':', lu)
                end
            end
           f:write('\n')
           generate_code_from_trie(f, n + 1, trieref[l])
        end
        ::continue::
    end
    f:writef('%s}\n', indent0)
    if n == 0 then
        f:write('    return -1;\n}\n')
    end
end

function locate_long_endings(trieref)
    local names = table.keys(trieref)
    local num = #names
    if num == 1 and names[1] == 'val' then
        return 1, '', trieref['val']
    end
    if num == 1 then
        local res, suffix, name = locate_long_endings(trieref[names[1]])
        local e = names[1] .. suffix
        if res == 1 then
            trieref['suffix'] = e
            trieref['name'] = name
        end
        return res, e, name
    end
    for _, l in ipairs(names) do
        if l ~= 'val' and l ~= 'name' and l ~= 'suffix' then
            locate_long_endings(trieref[l])
        end
    end
    return 0, '', nil
end

local stringbuilder = {}

function stringbuilder.new()
    local instance = table.inherit(stringbuilder)
    instance.buf = ""
    return instance
end

function stringbuilder:write(str)
    self.buf = self.buf .. str
end

function stringbuilder:writef(str, ...)
    self.buf = self.buf .. string.format(str, ...)
end

function stringbuilder:string()
    return self.buf
end

function produce_decoder()
    local t = generate_trie()
    locate_long_endings(t)
    local sb = stringbuilder.new()
    generate_code_from_trie(sb, 0, t)
    return sb:string()
end

-- function main()
--     print(produce_decoder())
-- end
