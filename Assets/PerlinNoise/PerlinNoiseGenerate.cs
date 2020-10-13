using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PerlinNoiseGenerate : MonoBehaviour
{

    public int Width = 256;
    public int Height = 256;

    public float scale = 20f;
    public Material material;

    public float OffsetX;
    public float OffsetY;

    [Range(0, 2)]
    public float brightness = 1f;
    [Range(0,2)]
    public float contrast = 1f;

    public bool useCurve;
    public AnimationCurve _curve;

    public bool useAnimation;

    public bool inUpdate;
    private void Start()
    {
        material = GetComponent<Renderer>().material;
        material.mainTexture = GenerateTexture();
    }

    private void Update()
    {
        if (inUpdate)
        {
            material.mainTexture = GenerateTexture();
        }
    }

    private Texture2D GenerateTexture()
    {
        Texture2D texture = new Texture2D(Width, Height);

        for (int x = 0; x < Width; x++)
        {
            for (int y = 0; y < Height; y++)
            {
                Color color = useCurve ? CalculateColor(x,y, _curve) : CalculateColor(x, y);
                texture.SetPixel(x, y, color);
            }
        }
        texture.Apply();
        return texture;
    }

    Color CalculateColor(int x, int y, AnimationCurve curve = null)
    {
        float xCoord = (float) x / Width * scale + OffsetX;
        float yCoord = (float) y / Height * scale + OffsetY;

        float sample = Mathf.PerlinNoise(xCoord, yCoord);
        sample = sample * brightness;
        sample = (sample - 0.5f) * contrast + 0.5f;
        if(curve != null)
        {
            sample = curve.Evaluate(sample);
        }
        return new Color(sample, sample, sample);
    }


}
