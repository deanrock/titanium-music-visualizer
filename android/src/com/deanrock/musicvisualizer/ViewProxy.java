package com.deanrock.musicvisualizer;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.TiC;
import org.appcelerator.titanium.util.Log;
import org.appcelerator.titanium.util.TiConfig;
import org.appcelerator.titanium.util.TiConvert;
import org.appcelerator.titanium.proxy.TiViewProxy;
import org.appcelerator.titanium.view.TiCompositeLayout;
import org.appcelerator.titanium.view.TiCompositeLayout.LayoutArrangement;
import org.appcelerator.titanium.view.TiUIView;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.audiofx.Visualizer;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.MediaController;
import android.app.Activity;
import android.net.Uri;
import android.content.pm.PackageManager;
import android.Manifest;
import java.io.FileFilter;
import android.support.v4.content.ContextCompat;
import 	android.support.v4.app.ActivityCompat;
import android.os.Environment;

import android.Manifest;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.media.AudioManager;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaPlayer;
import android.media.audiofx.Visualizer;
import android.media.audiofx.Visualizer;
import android.net.Uri;
import android.provider.Settings;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.os.Bundle;
import android.view.View;
import android.widget.MediaController;
import android.widget.MediaController;
import android.widget.Toast;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.AsyncResult;
import org.appcelerator.kroll.common.TiMessenger;
import org.appcelerator.titanium.TiApplication;
import org.appcelerator.titanium.TiContext;
import org.appcelerator.titanium.view.TiUIView;
import org.appcelerator.titanium.proxy.TiViewProxy;

import android.app.Activity;
import android.os.Handler;
import android.os.Message;


import java.io.File;
@Kroll.proxy(creatableInModule=MusicVisualizerModule.class)
public class ViewProxy extends TiViewProxy
{
	// Standard Debugging variables
	private static final String LCAT = "MusicVisualizerProxy";
	private static final boolean DBG = TiConfig.LOGD;

	private Activity activity;
	

	// Constructor
	public ViewProxy()
	{
		super();
	}

	@Kroll.method
	public boolean load(final String path)
	{
        final MusicVisualizerView view = (MusicVisualizerView)getOrCreateView();

        if (!TiApplication.isUIThread()) {
            Object obj = TiMessenger.sendBlockingMainMessage(new Handler(TiMessenger.getMainMessenger().getLooper(), new Handler.Callback() {
                public boolean handleMessage(Message msg) {
                    switch (msg.what) {
                        case MSG_SET_PROPERTY: {
                            AsyncResult result = (AsyncResult) msg.obj;
                            boolean r = view.load(path);
                            result.setResult(r);
                            return true;
                        }
                    }
                    return false;
                }
            }).obtainMessage(MSG_SET_PROPERTY), path);

            return (Boolean)obj;
        }else{
            return view.load(path);
        }
	}

	@Override
	public TiUIView createView(Activity activity)
	{
		this.activity = activity;
		MusicVisualizerView view = new MusicVisualizerView(this);
		view.getLayoutParams().autoFillsHeight = true;
		view.getLayoutParams().autoFillsWidth = true;
        view.init();
		return view;
	}

    @Kroll.method
    public void play() {
        final MusicVisualizerView view = (MusicVisualizerView)getOrCreateView();
        view.start();
    }

    @Kroll.method
    public void pause() {
        final MusicVisualizerView view = (MusicVisualizerView)getOrCreateView();
        view.pause();
    }

    @Kroll.method
    public void seek(float position) {
        final MusicVisualizerView view = (MusicVisualizerView)getOrCreateView();
        view.seekTo((int)(position * 1000));
    }

    @Kroll.method
    public float getCurrentPosition() {
        final MusicVisualizerView view = (MusicVisualizerView)getOrCreateView();
        return (float)view.getCurrentPosition() / 1000;
    }

    @Kroll.method
    public float getDuration() {
        final MusicVisualizerView view = (MusicVisualizerView)getOrCreateView();
        return (float)view.getDuration() / 1000;
    }

    @Kroll.method
    public void setVolume(float volume) {
        final MusicVisualizerView view = (MusicVisualizerView)getOrCreateView();
        view.setVolume(volume);
    }

    @Kroll.setProperty(retain=false)
    public void lineColor(final String color) 
    {
        final MusicVisualizerView view = (MusicVisualizerView)getOrCreateView();
        
        TiMessenger.postOnMain(new Runnable() {
            @Override
            public void run() {
                view.setLineColor(color);
            }
        });
    }
}
