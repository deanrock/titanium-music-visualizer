package com.deanrock.musicvisualizer;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;

/**
 * Created by Grega on 4.7.2016.
 */
public class VisualizerView extends View {

    static final float kDefaultFrequency = 1.0f;
    static final float kDefaultAmplitude = 0.6f;
    static final float kDefaultIdleAmplitude = 0.07f;
    static final float kDefaultNumberOfWaves = 3.0f;
    static final float kDefaultPhaseShift = -0.40f;
    static final float kDefaultDensity = 2.0f;
    static final float kDefaultPrimaryLineWidth = 0.5f;
    static final float kDefaultSecondaryLineWidth = 0.5f;

    private float amplitude;
    private float phase;
    float[] frequency;

    private Rect mRect = new Rect();
    private Paint mForePaint = new Paint();
    private Paint mLinePaint = new Paint();
    float[] startingPoint;
    Path path;

    public VisualizerView(Context context) {
        super(context);
        init();
    }

    public VisualizerView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public void setColor(int R,int G, int B)
    {
        mLinePaint.setStrokeWidth(0.1f);
        mLinePaint.setAntiAlias(true);
        mLinePaint.setColor(Color.argb(30, R, G, B));
        mForePaint.setStrokeWidth(1f);
        mForePaint.setAntiAlias(true);
        mForePaint.setColor(Color.argb(30, R, G, B));
    }

    public VisualizerView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private void init() {

        startingPoint = new float[(int) kDefaultNumberOfWaves];
        mLinePaint.setStrokeWidth(0.1f);
        mLinePaint.setAntiAlias(true);
        mLinePaint.setColor(Color.argb(30, 0, 0, 0));
        mForePaint.setStrokeWidth(1f);
        mForePaint.setAntiAlias(true);
        mForePaint.setColor(Color.argb(30, 0, 0, 0));
        frequency = new float[]{(float) (kDefaultPhaseShift * 1.3), (float) kDefaultPhaseShift, (float) (kDefaultPhaseShift * 0.8)};
        amplitude = kDefaultAmplitude;
    }

    public void updateVisualizer(byte[] bytes) {

        //
        float accumulator = 0;
        for (int i = 0; i < bytes.length - 1; i++) {
            accumulator += Math.abs(bytes[i]);
        }

        //z 0-45 uravnavamo višino amplitude
        float amp0 = (float)(accumulator / (128 * bytes.length)-0.45);

        invalidate();

        phase -= kDefaultPhaseShift;
        //amplitude = Math.max(amp0, kDefaultIdleAmplitude);
        if(Float.compare(amp0,(float)0.54902345)==0)
        {
            if(amplitude!=kDefaultIdleAmplitude&&amplitude>kDefaultIdleAmplitude)
            {
                amplitude=amplitude-(amplitude/3);
            }
            else
            {
                amplitude=kDefaultIdleAmplitude;
            }
        }
        else
        {
            amplitude=amp0;
        }
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        mRect.set(0, 0, getWidth(), getHeight());
        // We draw multiple sinus waves, with equal phases but altered amplitudes, multiplied by a parable function.
        for (int i = 0; i < kDefaultNumberOfWaves; i++) {
            float height = (float) (getHeight() / 1.6);
            float halfHeight = (float) (height / 2.0f + 90.0 * i);

            float width = getWidth();
            float mid = width / 2.0f;
            float progress = (float) (0.9 - (float) (i / kDefaultNumberOfWaves));
            float normedAmplitude = (float) ((1.5f * progress - 0.5f) * amplitude * 1.2);
            float maxAmplitude = halfHeight - 4.0f;

            path = new Path();

            for (float x = 0; x < width + 6.0 + kDefaultDensity; x += kDefaultDensity) {
                // We use a parable to scale the sinus wave, that has its peak in the middle of the view.
                float scaling = (float) (-Math.pow((1 / mid * (x - mid)), 2) + 1);

                float y = (float) (scaling * maxAmplitude * normedAmplitude * Math.sin(2 * Math.PI * (x / width) * frequency[i] * 1.8 + phase)) + halfHeight;

                if (x == 0) {
                    float start = .0f;
                    if (startingPoint[i] != 0.0f) {
                        start = startingPoint[i];
                    } else {
                        start = y;
                        startingPoint[i] = y;
                    }
                    path.moveTo((float) -3.0, start);
                } else {
                    path.lineTo(x, y);
                }

            }
            path.lineTo((float) (width + 3.0), (float) (height + 3.0));
            path.lineTo((float) -3.0, (float) (height + 3.0));
            canvas.drawPath(path, mForePaint);
            canvas.drawPath(path,mLinePaint);
        }
    }

}
