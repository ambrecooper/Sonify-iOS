//
//  ViewController.swift
//  Sonify
//
//  Created by Haden Pike on 5/9/16.
//  Copyright © 2016 Sonify. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate
{
    
    // toolbar objects
    @IBOutlet var photoButton: UIToolbar!
    @IBOutlet var helpButton: UIToolbar!
    @IBOutlet var settingsButton: UIToolbar!
    @IBOutlet var panButton: UIToolbar!
    
    @IBOutlet var imageView: UIImageView!
    
    var engine: AVAudioEngine!
    var tone: AVTonePlayerUnit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //create the tone
        tone = AVTonePlayerUnit()
        let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
        print(format.sampleRate)
        //make an engine
        engine = AVAudioEngine()
        engine.attachNode(tone)
        let mixer = engine.mainMixerNode
        engine.connect(tone, to: mixer, format: format)
        do {
            try engine.start()
        } catch let error as NSError {
            print(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  Called when the help button is pressed
    //  reads aloud a basic tutorial
    @IBAction func helpAction(sender: AnyObject)
    {
        let info = "To start, press Open in the lower left hand side of the screen to select your files. " +
            "To hear the descriptions, slide your finger across the screen. When your finger touches an area " +
            "of the image that can be described, the description will be read aloud. When there is no description " +
            "for that area you will hear a tone indicating where you are in the image. The higher the pitch, " +
            "the higher up you are in the image. There are four buttons located at the bottom of the screen. " +
        "From left to right they are Open, Pan, Settings and Help."
        let utterance = AVSpeechUtterance(string: info)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speakUtterance(utterance)
    }
    
    //  Called when settings buttion is pressed
    //  currently does nothing
    @IBAction func settingsAction(sender: AnyObject)
    {
        
    }
    
    //  Called when the pan button is pressed
    //  currently attempts to play aduio tone
    @IBAction func panAction(sender: AnyObject)
    {
        //let freq = 440.0 * pow(2.0, Double(2.5))
        let freq = ( ((view.frame.height-300)/view.frame.height)*700 + 261)
        tone.frequency = Double(freq)
        if tone.playing {
            engine.mainMixerNode.volume = 0.0
            tone.stop()
            sender.setTitle("Start", forState: .Normal)
        } else {
            tone.preparePlaying()
            tone.play()
            engine.mainMixerNode.volume = 1.0
            sender.setTitle("Stop", forState: .Normal)
        }
    }
    
    //  Callled when the camera button is pressed
    //  allows a user to select a photo from their library
    @IBAction func photoAction(sender: AnyObject)
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //  Used to open the user's photo library
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    //  When the user drags thier finger on the image
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        //  when their finger starts to drag
        if recognizer.state == UIGestureRecognizerState.Began {
            //  play tone
        }
        //  when they stop dragging their finger
        if recognizer.state == UIGestureRecognizerState.Ended {
            //  stop tone
        }
    }
    
    //  when the user taps on the screen
    @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
        //  check for description
            //  read if found
    }
    
}

