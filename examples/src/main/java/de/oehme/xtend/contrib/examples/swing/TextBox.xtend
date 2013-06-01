package de.oehme.xtend.contrib.examples.swing

import de.oehme.xtend.contrib.swing.FiresEvent
import java.awt.BorderLayout
import java.awt.Dimension
import java.awt.event.WindowEvent
import java.awt.event.WindowFocusListener
import java.util.Date
import javax.swing.JButton
import javax.swing.JFrame
import javax.swing.JTextField
import javax.swing.event.ChangeEvent
import javax.swing.event.ChangeListener

@FiresEvent(typeof(ChangeListener))
class MyTextBox1 extends JTextField {
	override setText(String s) {
		super.text = s
		new ChangeEvent(this).fireStateChanged //<- generated by @FiresEvent
	}
}

@FiresEvent(#[typeof(ChangeListener), typeof(WindowFocusListener)])
class MyTextBox2 extends JTextField {
	override setText(String s) {
		super.text = s
		new ChangeEvent(this).fireStateChanged //<- generated by @FiresEvent
		new WindowEvent(null, 0).fireWindowGainedFocus //<- generated by @FiresEvent
		new WindowEvent(null, 0).fireWindowLostFocus //<- generated by @FiresEvent
	}
}

class Window {
	def static void main(String[] args) {
		val textBox = new MyTextBox1 => [
			editable = false
			text = 'press ok'
		]
		val frame = new JFrame("Change test") => [
			defaultCloseOperation = JFrame::EXIT_ON_CLOSE
			visible = true
			size = new Dimension(300, 100)
			locationRelativeTo = null //center
			contentPane => [
				add(textBox, BorderLayout::CENTER)
				add(
					new JButton("OK") => [
						addActionListener [
							textBox.text = (new Date).toString
						]
					], BorderLayout::SOUTH)
			]
		]

		textBox.addChangeListener [ //<- generated by @FiresEvent
			frame.title = textBox.text
		]
	}
}