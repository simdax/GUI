(
var a,b, window;

a=FlowView(nil, 450@300, windowTitle:"midi").front;
window=a.view.parent;

b=TabbedView2(a,400@300);
Button(a).string_("init Midi")
.action_{MIDIClient.init()};
//EZNumber(a);
16.do { |y|
	var bob=b.add("port"++y);
	bob.scroll.flow{arg a;
		16.collect({|x|
			var z, zz, slider;
			var prgm, bank;
			var f={	arg port, chan;
				MIDIOut(port).bankProg(chan,bank, prgm)
			};
			Button(a, 30@20)
			.string_("panic")
			.action_{
				MIDIOut(y).program(x, 123)
			};
			StaticText(a, 40@20).string_("chan"++x);
			z=EZNumber(a, 100@25, "bank", [0,32,0,1].asSpec,
				{arg s;
					bank=s.value;
					f.(y, x);
				}, bank=4
			);
			zz=EZNumber(a, 100@25, "prog", [0,127,0,1].asSpec,
				{arg s;
					prgm=s.value;
					f.(y, x);
					fork{0.2.wait;
						defer{slider.valueAction_(60)}
					}
				}, prgm=0
			);
			CheckBox(a, 50@25)
			.background_(Color.blue).string_("rand").action_{
				arg s;
				zz.valueAction_(127.rand);
				s.value_(false)
			};
			slider=EZSlider(a, 100@25, numberWidth:0, controlSpec:[0,127,0,1].asSpec).action_{
				arg s;
				MIDIOut(y).control(x, 7, s.value)
			};
			a.decorator.nextLine
		})
	}
}
)