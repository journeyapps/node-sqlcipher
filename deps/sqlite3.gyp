{
  'includes': [ 'common-sqlite.gypi' ],
  'target_defaults': {
    'default_configuration': 'Release',
    'cflags':[
      '-std=c99'
    ],
    'configurations': {
      'Debug': {
        'defines': [ 'DEBUG', '_DEBUG' ],
        'msvs_settings': {
          'VCCLCompilerTool': {
            'RuntimeLibrary': 1, # static debug
          },
        },
      },
      'Release': {
        'defines': [ 'NDEBUG' ],
        'msvs_settings': {
          'VCCLCompilerTool': {
            'RuntimeLibrary': 0, # static release
          },
        },
      }
    },
    'msvs_settings': {
      'VCCLCompilerTool': {
      },
      'VCLibrarianTool': {
      },
      'VCLinkerTool': {
        'GenerateDebugInformation': 'true',
      },
    },
    'conditions': [
      ['OS == "win"', {
        'defines': [
          'WIN32'
        ],
        'conditions': [
          ['target_arch == "ia32"', {
            'variables': {
              'openssl_root%': 'OpenSSL-Win32',
            }
          }, {
            'variables': {
              'openssl_root%': 'OpenSSL-Win64',
            }
          }]
        ],
        'link_settings': {
          'libraries': [
            '-llibeay32.lib',
            '-lssleay32.lib',
          ],
          'library_dirs': [
            '<(SHARED_INTERMEDIATE_DIR)/sqlcipher-amalgation-<@(sqlite_version)/<(openssl_root)'
          ]
        }
      }]
    ],
  },

  'targets': [
    {
      'target_name': 'action_before_build',
      'type': 'none',
      'hard_dependency': 1,
      'actions': [
        {
          'action_name': 'unpack_sqlite_dep',
          'inputs': [
            './sqlcipher-amalgation-<@(sqlite_version).tar.gz'
          ],
          'outputs': [
            '<(SHARED_INTERMEDIATE_DIR)/sqlcipher-amalgation-<@(sqlite_version)/sqlite3.c'
          ],
          'action': ['python','./extract.py','./sqlcipher-amalgation-<@(sqlite_version).tar.gz','<(SHARED_INTERMEDIATE_DIR)']
        }
      ],
      'direct_dependent_settings': {
        'include_dirs': [
          '<(SHARED_INTERMEDIATE_DIR)/sqlcipher-amalgation-<@(sqlite_version)/',
        ]
      },
    },
    {
      'target_name': 'sqlite3',
      'type': 'static_library',
      'include_dirs': [ '<(SHARED_INTERMEDIATE_DIR)/sqlcipher-amalgation-<@(sqlite_version)/' ],
      'dependencies': [
        'action_before_build'
      ],
      'sources': [
        '<(SHARED_INTERMEDIATE_DIR)/sqlcipher-amalgation-<@(sqlite_version)/sqlite3.c'
      ],
      'direct_dependent_settings': {
        'include_dirs': [ '<(SHARED_INTERMEDIATE_DIR)/sqlcipher-amalgation-<@(sqlite_version)/' ],
        'defines': [
          'SQLITE_THREADSAFE=1',
          'SQLITE_ENABLE_FTS3',
          'SQLITE_ENABLE_JSON1',
          'SQLITE_ENABLE_RTREE',
          'SQLITE_HAS_CODEC',
          'SQLITE_TEMP_STORE=2',
          'SQLITE_SECURE_DELETE'
        ],
      },
      'cflags_cc': [
          '-Wno-unused-value'
      ],
      'defines': [
        '_REENTRANT=1',
        'SQLITE_THREADSAFE=1',
        'SQLITE_ENABLE_FTS3',
        'SQLITE_ENABLE_JSON1',
        'SQLITE_ENABLE_RTREE',
        'SQLITE_HAS_CODEC',
        'SQLITE_TEMP_STORE=2',
        'SQLITE_SECURE_DELETE'
      ],
      'export_dependent_settings': [
        'action_before_build',
      ]
    },
    {
      "target_name": "action_after_build",
      "type": "none",
      "dependencies": [ "action_before_build" ],
      "conditions": [
        ["OS == \"win\"", {
          "copies": [
            {
              "files": [ '<(SHARED_INTERMEDIATE_DIR)/sqlcipher-amalgation-<@(sqlite_version)/<(openssl_root)/libeay32.dll' ],
              "destination": "<(PRODUCT_DIR)"
            }
          ],
        }]
      ]
    }
  ]
}
