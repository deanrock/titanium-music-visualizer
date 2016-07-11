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
import java.io.File;
import android.view.ViewGroup.LayoutParams;
import android.view.View;
import java.io.IOException;


public class MusicVisualizerView extends TiUIView implements MediaController.MediaPlayerControl, MediaPlayer.OnPreparedListener
	{
    private static final String LCAT = "MusicVisualizerView";
    private static final boolean DBG = TiConfig.LOGD;

	TiViewProxy proxy;

    VisualizerView mVisualizerView;

    private MediaPlayer mMediaPlayer;
    private Visualizer mVisualizer;
    private MediaController mController;

	public MusicVisualizerView(TiViewProxy proxy) {
		super(proxy);

		this.proxy = proxy;

		LayoutArrangement arrangement = LayoutArrangement.DEFAULT;

		if (proxy.hasProperty(TiC.PROPERTY_LAYOUT)) {
			String layoutProperty = TiConvert.toString(proxy.getProperty(TiC.PROPERTY_LAYOUT));
			if (layoutProperty.equals(TiC.LAYOUT_HORIZONTAL)) {
				arrangement = LayoutArrangement.HORIZONTAL;
			} else if (layoutProperty.equals(TiC.LAYOUT_VERTICAL)) {
				arrangement = LayoutArrangement.VERTICAL;
			}
		}
		setNativeView(new TiCompositeLayout(proxy.getActivity(), arrangement));

		mVisualizerView = new VisualizerView(proxy.getActivity());

        TiCompositeLayout view = (TiCompositeLayout)getNativeView();
        view.addView(mVisualizerView, 0, new TiCompositeLayout.LayoutParams());
	}

	public void init() {
        proxy.getActivity().setVolumeControlStream(AudioManager.STREAM_MUSIC);
        mMediaPlayer = new MediaPlayer();

        mController = new MediaController(proxy.getActivity()){
            @Override
            public void show(int timeout) {
                super.show(0);
            }
        };
        
        // When the stream ends, we don't need to collect any more data. We
        // don't do this in
        // setupVisualizerFxAndUI because we likely want to have more,
        // non-Visualizer related code
        // in this callback.
        mMediaPlayer
            .setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                public void onCompletion(MediaPlayer mediaPlayer) {
                    mVisualizer.setEnabled(false);
                }
            });

        mMediaPlayer.setOnPreparedListener(this);


        //mMediaPlayer.start();

        mController.setEnabled(true);
        mController.show(0);
    }

    private void setupVisualizerFxAndUI() {
        mVisualizer = new Visualizer(mMediaPlayer.getAudioSessionId());
        mVisualizer.setCaptureSize(Visualizer.getCaptureSizeRange()[1]);
        mVisualizerView.setColor(0,0,0);
        mVisualizer.setDataCaptureListener(
                new Visualizer.OnDataCaptureListener() {
                    public void onWaveFormDataCapture(Visualizer visualizer,
                                                      final byte[] bytes, int samplingRate) {
                        proxy.getActivity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                mVisualizerView.updateVisualizer(bytes);
                            }
                        });
                    }

                    public void onFftDataCapture(Visualizer visualizer,
                                                 byte[] bytes, int samplingRate) {
                    }
                }, (int) (Visualizer.getMaxCaptureRate()/1.0), true, false);
    }

    @Override
    public void start() {
        mMediaPlayer.start();
    }

    @Override
    public void pause() {
        mMediaPlayer.pause();
    }

    @Override
    public int getDuration() {
        return mMediaPlayer.getDuration();
    }

    @Override
    public int getCurrentPosition() {
        return mMediaPlayer.getCurrentPosition();
    }

    @Override
    public void seekTo(int pos) {
        mMediaPlayer.seekTo(pos);
    }

    @Override
    public boolean isPlaying() {
        return mMediaPlayer.isPlaying();
    }

    @Override
    public int getBufferPercentage() {
        return mMediaPlayer.getCurrentPosition();
    }

    @Override
    public boolean canPause() {
        return true;
    }

    @Override
    public boolean canSeekBackward() {
        return true;
    }

    @Override
    public boolean canSeekForward() {
        return true;
    }

    @Override
    public int getAudioSessionId() {
        return mMediaPlayer.getAudioSessionId();
    }

    public void setVolume(float volume) {
        int soundVolume = (int)(volume*(float)100);
        int MAX_VOLUME = 101;
        final float v = (float) (1 - (Math.log(MAX_VOLUME - soundVolume) / Math.log(MAX_VOLUME)));
        mMediaPlayer.setVolume(v, v);
    }

    @Override
    public void onPrepared(MediaPlayer mp) {
        mController.setMediaPlayer(this);
        mController.setAnchorView(mVisualizerView);

    }

    public void setLineColor(String color) {
        int newColor = TiConvert.toColor(color);

        int r = (newColor >> 16) & 0xFF;
        int g = (newColor >> 8) & 0xFF;
        int b = (newColor >> 0) & 0xFF;

        mVisualizerView.setColor(r, g, b);
    }

	public boolean load(String path)
	{
        File file = new File(path);
        Log.d(LCAT, "file exists: " + file.exists());

        try {
            mMediaPlayer.setDataSource(path);
            mMediaPlayer.prepare();
            //mMediaPlayer.start();
        }catch(IOException exception) {
            Log.d("error", "IOException: " + exception);
            return false;
        }

        setupVisualizerFxAndUI();
        // Make sure the visualizer is enabled only when you actually want to
        // receive data, and
        // when it makes sense to receive data.
        mVisualizer.setEnabled(true);

        return true;
	}

	@Override
	public void processProperties(KrollDict d)
	{
		super.processProperties(d);
	}
}
