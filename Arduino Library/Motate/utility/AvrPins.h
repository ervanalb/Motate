/*
  utility/AvrPins.hpp - Library for the Arduino-compatible Motate system
  http://tinkerin.gs/

  Copyright (c) 2012 Robert Giseburt

	This file is part of the Motate Library.

	The Motate Library is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	The Motate Library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with the Motate Library.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef AVRPINS_H_ONCE
#define AVRPINS_H_ONCE

#include <avr/io.h>
#include <util/atomic.h>

namespace Motate {
	enum PinSetupType {
		Unchanged       = 0,
		Output          = 1,
		Input           = 2,
		InputWithPullup = 3,
	};

	template <unsigned char portLetter>
	struct Port8 {
		typedef uint8_t uintPort_t;
		static const uint8_t letter = (uint8_t) portLetter;
		
		void setDirection(const uint8_t value, const uint8_t mask = 0xff) {
			// stub
		};
		void setPins(const uint8_t value, const uint8_t mask = 0xff) {
			// stub
		};
		uint8_t getPins(const uint8_t mask = 0xff) {
			// stub
			return 0;
		};
	};
	
	template<int8_t pinNum>
	struct Pin {
	};
	
	typedef const int8_t pin_number;
	
	#define _MAKE_MOTATE_PIN(pinNum, registerLetter, registerChar, registerPin)\
		template<>\
		struct Pin<pinNum> /*: public PinBase*/ {\
			static const int8_t number = pinNum;\
			static const uint8_t portLetter = (uint8_t) registerChar;\
			static const uint8_t mask = (1 << registerPin);\
				\
			Pin(const PinSetupType type = Unchanged) {\
				init(type);\
			};\
			Pin<pinNum> &operator=(const bool value) { set(value); return *this; };\
			operator bool() { return (get() != 0); };\
		\
			void init(const PinSetupType type) {\
				switch (type) {\
					case Output:\
						(DDR ## registerLetter) |= _BV(registerPin);\
						break;\
					case InputWithPullup:\
					case Input:\
						(DDR ## registerLetter) &= ~_BV(registerPin);\
						break;\
					default:\
						break;\
				}\
				if (type == InputWithPullup)  (PORT ## registerLetter) |= _BV(registerPin);\
			};\
			void set(bool value)  {\
				if (!value)\
					(PORT ## registerLetter) &= ~_BV(registerPin);\
				else\
					(PORT ## registerLetter) |= _BV(registerPin);\
			};\
			uint8_t get() {\
				return (PIN ## registerLetter) & _BV(registerPin);\
			};\
			bool isNull() { return false; };\
			static uint8_t maskForPort(const uint8_t otherPortLetter) {\
				return portLetter == otherPortLetter ? mask : 0x00;\
			};\
		};\
		typedef Pin<pinNum> Pin ## pinNum;\
		static Pin ## pinNum pin ## pinNum;


	#define _MAKE_MOTATE_PORT8(registerLetter, registerChar)\
	template <> inline void Port8<registerChar>::setDirection(const uint8_t value, const uint8_t mask) {\
		uint8_t port_value = 0;\
		if (mask != 0xff) {\
			port_value = (DDR ## registerLetter) & mask;\
		}\
		(DDR ## registerLetter) = port_value | value;\
	};\
	template <> inline void Port8<registerChar>::setPins(const uint8_t value, const uint8_t mask) {\
		uint8_t port_value = 0;\
		if (mask != 0xff) {\
			port_value = (PORT ## registerLetter) & mask;\
		}\
		(PORT ## registerLetter) = port_value | value;\
	};\
	template <> inline uint8_t Port8<registerChar>::getPins(const uint8_t mask) {\
		return (PIN ## registerLetter) & (mask);\
	}\
	typedef Port8<registerChar> Port ## registerLetter;\
	static Port ## registerLetter port ## registerLetter;

	typedef Pin<-1> NullPin;
	static NullPin nullPin;

	#if defined(__AVR_ATmega168__) || defined(__AVR_ATmega328P__)

	// standard (UNO, etc)
		_MAKE_MOTATE_PORT8(B, 'B');
		_MAKE_MOTATE_PORT8(C, 'C');
		_MAKE_MOTATE_PORT8(D, 'D');

		_MAKE_MOTATE_PIN( 0, D, 'D', 0);
		_MAKE_MOTATE_PIN( 1, D, 'D', 1);
		_MAKE_MOTATE_PIN( 2, D, 'D', 2);
		_MAKE_MOTATE_PIN( 3, D, 'D', 3);
		_MAKE_MOTATE_PIN( 4, D, 'D', 4);
		_MAKE_MOTATE_PIN( 5, D, 'D', 5);
		_MAKE_MOTATE_PIN( 6, D, 'D', 6);
		_MAKE_MOTATE_PIN( 7, D, 'D', 7);
		_MAKE_MOTATE_PIN( 8, B, 'B', 0);
		_MAKE_MOTATE_PIN( 9, B, 'B', 1);
		_MAKE_MOTATE_PIN(10, B, 'B', 2);
		_MAKE_MOTATE_PIN(11, B, 'B', 3);
		_MAKE_MOTATE_PIN(12, B, 'B', 4);
		_MAKE_MOTATE_PIN(13, B, 'B', 5);
		_MAKE_MOTATE_PIN(14, C, 'C', 0);
		_MAKE_MOTATE_PIN(15, C, 'C', 1);
		_MAKE_MOTATE_PIN(16, C, 'C', 2);
		_MAKE_MOTATE_PIN(17, C, 'C', 3);
		_MAKE_MOTATE_PIN(18, C, 'C', 4);
		_MAKE_MOTATE_PIN(19, C, 'C', 5);

	#elif defined(__AVR_ATmega32U4__)

	// leonardo
		_MAKE_MOTATE_PORT8(B, 'B');
		_MAKE_MOTATE_PORT8(C, 'C');
		_MAKE_MOTATE_PORT8(D, 'D');
		_MAKE_MOTATE_PORT8(E, 'E');
		_MAKE_MOTATE_PORT8(F, 'F');

		_MAKE_MOTATE_PIN(0 , D, 'D', 2);
		_MAKE_MOTATE_PIN(1 , D, 'D', 3);
		_MAKE_MOTATE_PIN(2 , D, 'D', 1);
		_MAKE_MOTATE_PIN(3 , D, 'D', 0);
		_MAKE_MOTATE_PIN(4 , D, 'D', 4);
		_MAKE_MOTATE_PIN(5 , C, 'C', 6);
		_MAKE_MOTATE_PIN(6 , D, 'D', 7);
		_MAKE_MOTATE_PIN(7 , E, 'E', 6);

		_MAKE_MOTATE_PIN(8 , B, 'B', 4);
		_MAKE_MOTATE_PIN(9 , B, 'B', 5);
		_MAKE_MOTATE_PIN(10, B, 'B', 6);
		_MAKE_MOTATE_PIN(11, B, 'B', 7);
		_MAKE_MOTATE_PIN(12, D, 'D', 6);
		_MAKE_MOTATE_PIN(13, C, 'C', 7);

		_MAKE_MOTATE_PIN(14, B, 'B', 3);
		_MAKE_MOTATE_PIN(15, B, 'B', 1);
		_MAKE_MOTATE_PIN(16, B, 'B', 2);
		_MAKE_MOTATE_PIN(17, B, 'B', 0);

		_MAKE_MOTATE_PIN(18, F, 'F', 7);
		_MAKE_MOTATE_PIN(19, F, 'F', 6);
		_MAKE_MOTATE_PIN(20, F, 'F', 5);
		_MAKE_MOTATE_PIN(21, F, 'F', 4);
		_MAKE_MOTATE_PIN(22, F, 'F', 1);
		_MAKE_MOTATE_PIN(23, F, 'F', 0);

		_MAKE_MOTATE_PIN(24, D, 'D', 4);
		_MAKE_MOTATE_PIN(25, D, 'D', 7);
		_MAKE_MOTATE_PIN(26, B, 'B', 4);
		_MAKE_MOTATE_PIN(27, B, 'B', 5);
		_MAKE_MOTATE_PIN(28, B, 'B', 6);
		_MAKE_MOTATE_PIN(29, D, 'D', 6);

	#elif defined(__AVR_ATmega1280__) || defined(__AVR_ATmega2560__)

	// MEGA
		_MAKE_MOTATE_PORT8(A, 'A');
		_MAKE_MOTATE_PORT8(B, 'B');
		_MAKE_MOTATE_PORT8(C, 'C');
		_MAKE_MOTATE_PORT8(D, 'D');
		_MAKE_MOTATE_PORT8(E, 'E');
		_MAKE_MOTATE_PORT8(F, 'F');
		_MAKE_MOTATE_PORT8(G, 'G');
		_MAKE_MOTATE_PORT8(H, 'H');

		_MAKE_MOTATE_PORT8(J, 'J');
		_MAKE_MOTATE_PORT8(K, 'K');
		_MAKE_MOTATE_PORT8(L, 'L');

		_MAKE_MOTATE_PIN(0 , E, 'E', 0);
		_MAKE_MOTATE_PIN(1 , E, 'E', 1);
		_MAKE_MOTATE_PIN(2 , E, 'E', 4);
		_MAKE_MOTATE_PIN(3 , E, 'E', 5);
		_MAKE_MOTATE_PIN(4 , G, 'G', 5);
		_MAKE_MOTATE_PIN(5 , E, 'E', 3);
		_MAKE_MOTATE_PIN(6 , H, 'H', 3);
		_MAKE_MOTATE_PIN(7 , H, 'H', 4);
		_MAKE_MOTATE_PIN(8 , H, 'H', 5);
		_MAKE_MOTATE_PIN(9 , H, 'H', 6);
		_MAKE_MOTATE_PIN(10, B, 'B', 4);
		_MAKE_MOTATE_PIN(11, B, 'B', 5);
		_MAKE_MOTATE_PIN(12, B, 'B', 6);
		_MAKE_MOTATE_PIN(13, B, 'B', 7);
		_MAKE_MOTATE_PIN(14, J, 'J', 1);
		_MAKE_MOTATE_PIN(15, J, 'J', 0);
		_MAKE_MOTATE_PIN(16, H, 'H', 1);
		_MAKE_MOTATE_PIN(17, H, 'H', 0);
		_MAKE_MOTATE_PIN(18, D, 'D', 3);
		_MAKE_MOTATE_PIN(19, D, 'D', 2);
		_MAKE_MOTATE_PIN(20, D, 'D', 1);
		_MAKE_MOTATE_PIN(21, D, 'D', 0);
		_MAKE_MOTATE_PIN(22, A, 'A', 0);
		_MAKE_MOTATE_PIN(23, A, 'A', 1);
		_MAKE_MOTATE_PIN(24, A, 'A', 2);
		_MAKE_MOTATE_PIN(25, A, 'A', 3);
		_MAKE_MOTATE_PIN(26, A, 'A', 4);
		_MAKE_MOTATE_PIN(27, A, 'A', 5);
		_MAKE_MOTATE_PIN(28, A, 'A', 6);
		_MAKE_MOTATE_PIN(29, A, 'A', 7);
		_MAKE_MOTATE_PIN(30, C, 'C', 7);
		_MAKE_MOTATE_PIN(31, C, 'C', 6);
		_MAKE_MOTATE_PIN(32, C, 'C', 5);
		_MAKE_MOTATE_PIN(33, C, 'C', 4);
		_MAKE_MOTATE_PIN(34, C, 'C', 3);
		_MAKE_MOTATE_PIN(35, C, 'C', 2);
		_MAKE_MOTATE_PIN(36, C, 'C', 1);
		_MAKE_MOTATE_PIN(37, C, 'C', 0);
		_MAKE_MOTATE_PIN(38, D, 'D', 7);
		_MAKE_MOTATE_PIN(39, G, 'G', 2);
		_MAKE_MOTATE_PIN(40, G, 'G', 1);
		_MAKE_MOTATE_PIN(41, G, 'G', 0);
		_MAKE_MOTATE_PIN(42, L, 'L', 7);
		_MAKE_MOTATE_PIN(43, L, 'L', 6);
		_MAKE_MOTATE_PIN(44, L, 'L', 5);
		_MAKE_MOTATE_PIN(45, L, 'L', 4);
		_MAKE_MOTATE_PIN(46, L, 'L', 3);
		_MAKE_MOTATE_PIN(47, L, 'L', 2);
		_MAKE_MOTATE_PIN(48, L, 'L', 1);
		_MAKE_MOTATE_PIN(49, L, 'L', 0);
		_MAKE_MOTATE_PIN(50, B, 'B', 3);
		_MAKE_MOTATE_PIN(51, B, 'B', 2);
		_MAKE_MOTATE_PIN(52, B, 'B', 1);
		_MAKE_MOTATE_PIN(53, B, 'B', 0);
		_MAKE_MOTATE_PIN(54, F, 'F', 0);
		_MAKE_MOTATE_PIN(55, F, 'F', 1);
		_MAKE_MOTATE_PIN(56, F, 'F', 2);
		_MAKE_MOTATE_PIN(57, F, 'F', 3);
		_MAKE_MOTATE_PIN(58, F, 'F', 4);
		_MAKE_MOTATE_PIN(59, F, 'F', 5);
		_MAKE_MOTATE_PIN(60, F, 'F', 6);
		_MAKE_MOTATE_PIN(61, F, 'F', 7);
		_MAKE_MOTATE_PIN(62, K, 'K', 0);
		_MAKE_MOTATE_PIN(63, K, 'K', 1);
		_MAKE_MOTATE_PIN(64, K, 'K', 2);
		_MAKE_MOTATE_PIN(65, K, 'K', 3);
		_MAKE_MOTATE_PIN(66, K, 'K', 4);
		_MAKE_MOTATE_PIN(67, K, 'K', 5);
		_MAKE_MOTATE_PIN(68, K, 'K', 6);
		_MAKE_MOTATE_PIN(69, K, 'K', 7);

	#endif

	// PinHolder - virtual ports
	template<uint8_t PinBit7num, uint8_t PinBit6num, uint8_t PinBit5num = -1, uint8_t PinBit4num = -1, uint8_t PinBit3num = -1, uint8_t PinBit2num = -1, uint8_t PinBit1num = -1, uint8_t PinBit0num = -1>
	class PinHolder8 {

		static Pin<PinBit7num> PinBit7;
		static Pin<PinBit6num> PinBit6;
		static Pin<PinBit5num> PinBit5;
		static Pin<PinBit4num> PinBit4;
		static Pin<PinBit3num> PinBit3;
		static Pin<PinBit2num> PinBit2;
		static Pin<PinBit1num> PinBit1;
		static Pin<PinBit0num> PinBit0;

#define _MOTATE_CREATE_CLEAR_AND_COPY_MASKS(aPortLetter) \
		static const uint8_t port ## aPortLetter ## ClearMask =\
			(Pin<PinBit7num>::portLetter == Port ## aPortLetter::letter ? Pin<PinBit7num>::mask : 0x00) |\
			(Pin<PinBit6num>::portLetter == Port ## aPortLetter::letter ? Pin<PinBit6num>::mask : 0x00) |\
			(Pin<PinBit5num>::portLetter == Port ## aPortLetter::letter ? Pin<PinBit5num>::mask : 0x00) |\
			(Pin<PinBit4num>::portLetter == Port ## aPortLetter::letter ? Pin<PinBit4num>::mask : 0x00) |\
			(Pin<PinBit3num>::portLetter == Port ## aPortLetter::letter ? Pin<PinBit3num>::mask : 0x00) |\
			(Pin<PinBit2num>::portLetter == Port ## aPortLetter::letter ? Pin<PinBit2num>::mask : 0x00) |\
			(Pin<PinBit1num>::portLetter == Port ## aPortLetter::letter ? Pin<PinBit1num>::mask : 0x00) |\
			(Pin<PinBit0num>::portLetter == Port ## aPortLetter::letter ? Pin<PinBit0num>::mask : 0x00);\
\
		static const uint8_t port ## aPortLetter ## CopyMask =\
			(Pin<PinBit7num>::portLetter == Port ## aPortLetter::letter && Pin<PinBit7num>::mask == (1 << 7 ) \
				? Pin<PinBit7num>::mask : 0x00) |\
			(Pin<PinBit6num>::portLetter == Port ## aPortLetter::letter && Pin<PinBit6num>::mask == (1 << 6 )\
				? Pin<PinBit6num>::mask : 0x00) |\
			(Pin<PinBit5num>::portLetter == Port ## aPortLetter::letter && Pin<PinBit5num>::mask == (1 << 5 )\
				? Pin<PinBit5num>::mask : 0x00) |\
			(Pin<PinBit4num>::portLetter == Port ## aPortLetter::letter && Pin<PinBit4num>::mask == (1 << 4 )\
				? Pin<PinBit4num>::mask : 0x00) |\
			(Pin<PinBit3num>::portLetter == Port ## aPortLetter::letter && Pin<PinBit3num>::mask == (1 << 3 )\
				? Pin<PinBit3num>::mask : 0x00) |\
			(Pin<PinBit2num>::portLetter == Port ## aPortLetter::letter && Pin<PinBit2num>::mask == (1 << 2 )\
				? Pin<PinBit2num>::mask : 0x00) |\
			(Pin<PinBit1num>::portLetter == Port ## aPortLetter::letter && Pin<PinBit1num>::mask == (1 << 1 )\
				? Pin<PinBit1num>::mask : 0x00) |\
			(Pin<PinBit0num>::portLetter == Port ## aPortLetter::letter && Pin<PinBit0num>::mask == (1 << 0 )\
				? Pin<PinBit0num>::mask : 0x00);

		_MOTATE_CREATE_CLEAR_AND_COPY_MASKS(B);
		_MOTATE_CREATE_CLEAR_AND_COPY_MASKS(C);
		_MOTATE_CREATE_CLEAR_AND_COPY_MASKS(D);
				
	public:
		PinHolder8() {
			
		};
		
		void set(uint8_t in_value) {
			uint8_t port_value    = 0x00; // Port<> handles reading the port and setting the masked pins
#define _MOTATE_PINHOLDER_CHECKANDSETPIN(portLetter, bitNumber, bitMask) \
			if (PinBit ## bitNumber.maskForPort(port ## portLetter.letter) &&\
					(PinBit ## bitNumber.mask != (bitMask)) && (in_value & (bitMask))) {\
				port_value |= PinBit ## bitNumber.mask;\
			}
			
#define _MOTATE_PINHOLDER_SETPORT(portLetter) \
			if (port ## portLetter ## ClearMask != 0x00) {\
				_MOTATE_PINHOLDER_CHECKANDSETPIN(portLetter, 7, 0b10000000);\
				_MOTATE_PINHOLDER_CHECKANDSETPIN(portLetter, 6, 0b01000000);\
				_MOTATE_PINHOLDER_CHECKANDSETPIN(portLetter, 5, 0b00100000);\
				_MOTATE_PINHOLDER_CHECKANDSETPIN(portLetter, 4, 0b00010000);\
				_MOTATE_PINHOLDER_CHECKANDSETPIN(portLetter, 3, 0b00001000);\
				_MOTATE_PINHOLDER_CHECKANDSETPIN(portLetter, 2, 0b00000100);\
				_MOTATE_PINHOLDER_CHECKANDSETPIN(portLetter, 1, 0b00000010);\
				_MOTATE_PINHOLDER_CHECKANDSETPIN(portLetter, 0, 0b00000001);\
				port_value |= in_value & port ## portLetter ## CopyMask;\
				port ## portLetter.setPins(port_value, ~port ## portLetter ## ClearMask);\
			}
			
			_MOTATE_PINHOLDER_SETPORT(B);
			_MOTATE_PINHOLDER_SETPORT(C);
			_MOTATE_PINHOLDER_SETPORT(D);
		}
		
	};
}
#endif /* end of include guard: AVRPINS_H_ONCE */