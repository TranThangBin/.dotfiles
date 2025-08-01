{
  preset = "LoudnessEqualizer";
  extraPresets = {
    LoudnessEqualizer = {
      output = {
        blocklist = [ ];
        "compressor#0" = {
          attack = 130;
          boost-amount = 6;
          boost-threshold = -60;
          bypass = false;
          dry = -100;
          hpf-frequency = 10;
          hpf-mode = "off";
          input-gain = 0;
          knee = -24;
          lpf-frequency = 20000;
          lpf-mode = "off";
          makeup = 0;
          mode = "Upward";
          output-gain = 0;
          ratio = 5;
          release = 600;
          release-threshold = -100;
          sidechain = {
            lookahead = 0;
            mode = "RMS";
            preamp = 0;
            reactivity = 10;
            source = "Middle";
            stereo-split-source = "Left/Right";
            type = "Feed-forward";
          };
          stereo-split = false;
          threshold = -10;
          wet = 0;
        };
        "equalizer#0" = {
          balance = 0;
          bypass = false;
          input-gain = 0;
          left = {
            band0 = {
              frequency = 32;
              gain = {
              };
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band1 = {
              frequency = 64;
              gain = 2;
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band2 = {
              frequency = 128;
              gain = 1;
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band3 = {
              frequency = 256;
              gain = 0;
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band4 = {
              frequency = 512;
              gain = {
              };
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band5 = {
              frequency = 1024;
              gain = {
              };
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band6 = {
              frequency = 2048;
              gain = {
              };
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band7 = {
              frequency = 4096;
              gain = {
              };
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band8 = {
              frequency = 8192;
              gain = {
              };
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band9 = {
              frequency = 16384;
              gain = 3;
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
          };
          mode = "IIR";
          num-bands = 10;
          output-gain = 0;
          pitch-left = 0;
          pitch-right = 0;
          right = {
            band0 = {
              frequency = 32;
              gain = {
              };
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band1 = {
              frequency = 64;
              gain = 2;
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band2 = {
              frequency = 128;
              gain = 1;
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band3 = {
              frequency = 256;
              gain = 0;
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band4 = {
              frequency = 512;
              gain = {
              };
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band5 = {
              frequency = 1024;
              gain = {
              };
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band6 = {
              frequency = 2048;
              gain = {
              };
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band7 = {
              frequency = 4096;
              gain = {
              };
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band8 = {
              frequency = 8192;
              gain = {
              };
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
            band9 = {
              frequency = 16384;
              gain = 3;
              mode = "RLC (BT)";
              mute = false;
              q = {
              };
              slope = "x1";
              solo = false;
              type = "Bell";
              width = 4;
            };
          };
          split-channels = false;
        };
        "gate#0" = {
          attack = 2000;
          bypass = false;
          curve-threshold = -40;
          curve-zone = -40;
          dry = -100;
          hpf-frequency = 10;
          hpf-mode = "off";
          hysteresis = false;
          hysteresis-threshold = -12;
          hysteresis-zone = -6;
          input-gain = 0;
          lpf-frequency = 20000;
          lpf-mode = "off";
          makeup = 0;
          output-gain = 0;
          reduction = -30;
          release = 2000;
          sidechain = {
            input = "Internal";
            lookahead = 0;
            mode = "Peak";
            preamp = 0;
            reactivity = 10;
            source = "Middle";
            stereo-split-source = "Left/Right";
          };
          stereo-split = false;
          wet = 0;
        };
        "limiter#0" = {
          alr = false;
          alr-attack = 5;
          alr-knee = 0;
          alr-release = 50;
          attack = 5;
          bypass = false;
          dithering = "None";
          external-sidechain = false;
          gain-boost = false;
          input-gain = 0;
          lookahead = 5;
          mode = "Herm Thin";
          output-gain = 0;
          oversampling = "Half x4(3L)";
          release = 10;
          sidechain-preamp = 0;
          stereo-link = 100;
          threshold = -1;
        };
        "multiband_compressor#0" = {
          band0 = {
            attack-threshold = -30;
            attack-time = 50;
            boost-amount = 6;
            boost-threshold = -72;
            compression-mode = "Downward";
            compressor-enable = true;
            external-sidechain = false;
            knee = -24;
            makeup = 0;
            mute = false;
            ratio = {
            };
            release-threshold = -100;
            release-time = 600;
            sidechain-custom-highcut-filter = false;
            sidechain-custom-lowcut-filter = false;
            sidechain-highcut-frequency = 250;
            sidechain-lookahead = 0;
            sidechain-lowcut-frequency = 10;
            sidechain-mode = "RMS";
            sidechain-preamp = 0;
            sidechain-reactivity = 10;
            sidechain-source = "Middle";
            solo = false;
            stereo-split-source = "Left/Right";
          };
          band1 = {
            attack-threshold = -30;
            attack-time = 30;
            boost-amount = 6;
            boost-threshold = -72;
            compression-mode = "Downward";
            compressor-enable = true;
            enable-band = true;
            external-sidechain = false;
            knee = -24;
            makeup = 0;
            mute = false;
            ratio = {
            };
            release-threshold = -100;
            release-time = 450;
            sidechain-custom-highcut-filter = false;
            sidechain-custom-lowcut-filter = false;
            sidechain-highcut-frequency = 1250;
            sidechain-lookahead = 0;
            sidechain-lowcut-frequency = 250;
            sidechain-mode = "RMS";
            sidechain-preamp = 0;
            sidechain-reactivity = 10;
            sidechain-source = "Middle";
            solo = false;
            split-frequency = 250;
            stereo-split-source = "Left/Right";
          };
          band2 = {
            attack-threshold = -30;
            attack-time = 10;
            boost-amount = 6;
            boost-threshold = -72;
            compression-mode = "Downward";
            compressor-enable = true;
            enable-band = true;
            external-sidechain = false;
            knee = -24;
            makeup = 0;
            mute = false;
            ratio = {
            };
            release-threshold = -100;
            release-time = 250;
            sidechain-custom-highcut-filter = false;
            sidechain-custom-lowcut-filter = false;
            sidechain-highcut-frequency = 5000;
            sidechain-lookahead = 0;
            sidechain-lowcut-frequency = 1250;
            sidechain-mode = "RMS";
            sidechain-preamp = 0;
            sidechain-reactivity = 10;
            sidechain-source = "Middle";
            solo = false;
            split-frequency = 1250;
            stereo-split-source = "Left/Right";
          };
          band3 = {
            attack-threshold = -30;
            attack-time = 5;
            boost-amount = 6;
            boost-threshold = -72;
            compression-mode = "Downward";
            compressor-enable = true;
            enable-band = true;
            external-sidechain = false;
            knee = -24;
            makeup = 0;
            mute = false;
            ratio = {
            };
            release-threshold = -100;
            release-time = 100;
            sidechain-custom-highcut-filter = false;
            sidechain-custom-lowcut-filter = false;
            sidechain-highcut-frequency = 20000;
            sidechain-lookahead = 0;
            sidechain-lowcut-frequency = 5000;
            sidechain-mode = "RMS";
            sidechain-preamp = 0;
            sidechain-reactivity = 10;
            sidechain-source = "Middle";
            solo = false;
            split-frequency = 5000;
            stereo-split-source = "Left/Right";
          };
          band4 = {
            attack-threshold = -12;
            attack-time = 20;
            boost-amount = 6;
            boost-threshold = -72;
            compression-mode = "Downward";
            compressor-enable = true;
            enable-band = false;
            external-sidechain = false;
            knee = -6;
            makeup = 0;
            mute = false;
            ratio = 1;
            release-threshold = -100;
            release-time = 100;
            sidechain-custom-highcut-filter = false;
            sidechain-custom-lowcut-filter = false;
            sidechain-highcut-frequency = 8000;
            sidechain-lookahead = 0;
            sidechain-lowcut-frequency = 4000;
            sidechain-mode = "RMS";
            sidechain-preamp = 0;
            sidechain-reactivity = 10;
            sidechain-source = "Middle";
            solo = false;
            split-frequency = 4000;
            stereo-split-source = "Left/Right";
          };
          band5 = {
            attack-threshold = -12;
            attack-time = 20;
            boost-amount = 6;
            boost-threshold = -72;
            compression-mode = "Downward";
            compressor-enable = true;
            enable-band = false;
            external-sidechain = false;
            knee = -6;
            makeup = 0;
            mute = false;
            ratio = 1;
            release-threshold = -100;
            release-time = 100;
            sidechain-custom-highcut-filter = false;
            sidechain-custom-lowcut-filter = false;
            sidechain-highcut-frequency = 12000;
            sidechain-lookahead = 0;
            sidechain-lowcut-frequency = 8000;
            sidechain-mode = "RMS";
            sidechain-preamp = 0;
            sidechain-reactivity = 10;
            sidechain-source = "Middle";
            solo = false;
            split-frequency = 8000;
            stereo-split-source = "Left/Right";
          };
          band6 = {
            attack-threshold = -12;
            attack-time = 20;
            boost-amount = 6;
            boost-threshold = -72;
            compression-mode = "Downward";
            compressor-enable = true;
            enable-band = false;
            external-sidechain = false;
            knee = -6;
            makeup = 0;
            mute = false;
            ratio = 1;
            release-threshold = -100;
            release-time = 100;
            sidechain-custom-highcut-filter = false;
            sidechain-custom-lowcut-filter = false;
            sidechain-highcut-frequency = 16000;
            sidechain-lookahead = 0;
            sidechain-lowcut-frequency = 12000;
            sidechain-mode = "RMS";
            sidechain-preamp = 0;
            sidechain-reactivity = 10;
            sidechain-source = "Middle";
            solo = false;
            split-frequency = 12000;
            stereo-split-source = "Left/Right";
          };
          band7 = {
            attack-threshold = -12;
            attack-time = 20;
            boost-amount = 6;
            boost-threshold = -72;
            compression-mode = "Downward";
            compressor-enable = true;
            enable-band = false;
            external-sidechain = false;
            knee = -6;
            makeup = 0;
            mute = false;
            ratio = 1;
            release-threshold = -100;
            release-time = 100;
            sidechain-custom-highcut-filter = false;
            sidechain-custom-lowcut-filter = false;
            sidechain-highcut-frequency = 20000;
            sidechain-lookahead = 0;
            sidechain-lowcut-frequency = 16000;
            sidechain-mode = "RMS";
            sidechain-preamp = 0;
            sidechain-reactivity = 10;
            sidechain-source = "Middle";
            solo = false;
            split-frequency = 16000;
            stereo-split-source = "Left/Right";
          };
          bypass = false;
          compressor-mode = "Modern";
          dry = -100;
          envelope-boost = "None";
          input-gain = 0;
          output-gain = 0;
          stereo-split = false;
          wet = 0;
        };
        plugins_order = [
          "gate#0"
          "compressor#0"
          "multiband_compressor#0"
          "equalizer#0"
          "limiter#0"
        ];
      };
    };
  };
}
